// @ts-nocheck
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

/**
 * Smartpay calls this URL as successCallback after a payment is completed.
 * URL format: POST /smartpay-webhook?secureId=<UUID>
 * Must return HTTP 200 to acknowledge receipt.
 */
serve(async (req) => {
  const url = new URL(req.url)
  const secureId = url.searchParams.get('secureId')

  if (!secureId) {
    // Smartpay sometimes sends a body-less POST; still return 200
    return new Response('OK', { status: 200 })
  }

  try {
    // Step 1: Authenticate with Smartpay
    const authRes = await fetch('https://apispay.esukh.mn/api/v1/merchant/auth', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: Deno.env.get('SMARTPAY_USERNAME'),
        password: Deno.env.get('SMARTPAY_PASSWORD'),
      }),
    })
    const authData = await authRes.json()
    if (!authData.success) {
      console.error('Smartpay auth failed in webhook', authData)
      return new Response('OK', { status: 200 }) // Always 200 to Smartpay
    }

    // Step 2: Check invoice status by secureId
    const checkRes = await fetch(
      `https://apispay.esukh.mn/api/v1/invoice/bySecureId/${secureId}/check`,
      {
        method: 'POST',
        headers: { Authorization: `Bearer ${authData.token}` },
      },
    )
    const checkData = await checkRes.json()

    if (checkData.status !== 'PAID') {
      // Not paid yet — return 200 so Smartpay doesn't retry unnecessarily
      return new Response('OK', { status: 200 })
    }

    // Step 3: Find the pending payment record by invoiceId
    const invoiceId = String(checkData.id)
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    )

    const { data: payment } = await supabase
      .from('payments')
      .select('id, booking_id, customer_id, coach_id, currency')
      .eq('provider_payment_id', invoiceId)
      .eq('status', 'pending')
      .single()

    if (!payment) {
      console.warn(`No pending payment found for invoiceId ${invoiceId}`)
      return new Response('OK', { status: 200 })
    }

    // Step 4: Update payment to paid + booking to confirmed
    await Promise.all([
      supabase
        .from('payments')
        .update({ status: 'paid' })
        .eq('id', payment.id),
      supabase
        .from('bookings')
        .update({ status: 'confirmed' })
        .eq('id', payment.booking_id),
    ])

    console.log(`Booking ${payment.booking_id} confirmed via Smartpay invoice ${invoiceId}`)
    return new Response('OK', { status: 200 })
  } catch (err) {
    console.error('smartpay-webhook error:', err)
    // Always return 200 to prevent Smartpay from retrying indefinitely
    return new Response('OK', { status: 200 })
  }
})
