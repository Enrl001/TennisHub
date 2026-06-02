// @ts-nocheck
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { bookingId, amount, description, phone } = await req.json()

    if (!bookingId || !amount) {
      return new Response(
        JSON.stringify({ error: 'bookingId and amount are required' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    const username = Deno.env.get('SMARTPAY_USERNAME')
    const password = Deno.env.get('SMARTPAY_PASSWORD')
    const accountNumber = Deno.env.get('SMARTPAY_ACCOUNT_NUMBER')
    if (!username || !password || !accountNumber) {
      return new Response(
        JSON.stringify({
          error: 'Smartpay is not configured. Set SMARTPAY_USERNAME, SMARTPAY_PASSWORD, and SMARTPAY_ACCOUNT_NUMBER in Supabase secrets.',
        }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const roundedAmount = Math.round(Number(amount))

    // Step 1: Authenticate with Smartpay (POST /api/v1/merchant/auth)
    const authRes = await fetch('https://apispay.esukh.mn/api/v1/merchant/auth', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password }),
    })
    const authData = await authRes.json()
    if (!authData.success) {
      return new Response(
        JSON.stringify({ error: 'Smartpay authentication failed', details: authData }),
        { status: 502, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    // Step 2: Create invoice
    const itemDescription = description ?? `MyClub Booking ${bookingId}`
    const webhookUrl = `${supabaseUrl}/functions/v1/smartpay-webhook`
    const invoiceBody: Record<string, unknown> = {
      amount: roundedAmount,
      description: itemDescription,
      returnUrl: `${supabaseUrl}/functions/v1/smartpay-return?bookingId=${bookingId}`,
      successCallback: webhookUrl,
      invoiceItems: [
        {
          amount: roundedAmount,
          accountNumber,
          bankCode: Deno.env.get('SMARTPAY_BANK_CODE') ?? '050000',
          description: itemDescription,
          productTypeId: Number(Deno.env.get('SMARTPAY_PRODUCT_TYPE_ID') ?? '1'),
          successCallback: webhookUrl,
          vatInfo: null,
        },
      ],
    }
    if (phone) invoiceBody.phone = phone

    const invoiceRes = await fetch('https://apispay.esukh.mn/api/v1/invoice', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${authData.token}`,
      },
      body: JSON.stringify(invoiceBody),
    })
    const invoiceData = await invoiceRes.json()
    if (!invoiceData.success) {
      return new Response(
        JSON.stringify({ error: 'Invoice creation failed', details: invoiceData }),
        { status: 502, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    // Step 3: Save invoiceId + create a pending payment record
    const supabase = createClient(
      supabaseUrl,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    )

    // Fetch booking to get customer/coach ids
    const { data: booking } = await supabase
      .from('bookings')
      .select('customer_id, coach_id, currency')
      .eq('id', bookingId)
      .single()

    await supabase.from('payments').insert({
      booking_id: bookingId,
      customer_id: booking?.customer_id,
      coach_id: booking?.coach_id,
      status: 'pending',
      amount: roundedAmount,
      currency: booking?.currency ?? 'MNT',
      provider_payment_id: String(invoiceData.invoiceId),
    })

    return new Response(
      JSON.stringify({
        invoiceId: invoiceData.invoiceId,
        url: invoiceData.url,
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  } catch (err) {
    console.error('create-smartpay-invoice error:', err)
    return new Response(
      JSON.stringify({ error: String(err) }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  }
})
