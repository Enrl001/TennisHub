// @ts-nocheck
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

function jsonResponse(body: Record<string, unknown>, status: number) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}

function smartpayOk(data: Record<string, unknown>): boolean {
  return data.success === true || data.Success === true
}

function smartpayToken(data: Record<string, unknown>): string | null {
  const token = data.token ?? data.Token ?? data.accessToken
  return typeof token === 'string' && token.length > 0 ? token : null
}

function smartpayMessage(data: Record<string, unknown>): string {
  const err = data.error
  if (err && typeof err === 'object') {
    const nested = err as Record<string, unknown>
    const nestedMsg = nested.message ?? nested.messageEng
    if (typeof nestedMsg === 'string' && nestedMsg.length > 0) return nestedMsg
  }
  const msg = data.message ?? data.Message ?? data.error ?? data.Error
  if (typeof msg === 'string' && msg.length > 0) return msg
  return JSON.stringify(data).slice(0, 300)
}

/**
 * Smartpay invoiceItems.accountNumber must be 8–12 digits.
 * Accepts full values like MN820005005570137879 (IBAN-style) and extracts
 * the domestic account segment Smartpay expects.
 */
function normalizeAccountNumber(raw: string | undefined): string | null {
  if (!raw) return null
  let cleaned = raw.trim().toUpperCase()
  if (cleaned.startsWith('MN')) cleaned = cleaned.slice(2)
  const digits = cleaned.replace(/\D/g, '')
  if (/^\d{8,12}$/.test(digits)) return digits

  // IBAN-style MN accounts are often 18 digits — Smartpay wants the last 10–12.
  if (digits.length > 12) {
    const mode = (Deno.env.get('SMARTPAY_ACCOUNT_EXTRACT') ?? 'last12').toLowerCase()
    const candidate =
      mode === 'last10'
        ? digits.slice(-10)
        : mode === 'last8'
          ? digits.slice(-8)
          : digits.slice(-12)
    if (/^\d{8,12}$/.test(candidate)) return candidate
  }
  return null
}

async function readSmartpayJson(res: Response, step: string) {
  const text = await res.text()
  let data: Record<string, unknown> = {}
  try {
    data = JSON.parse(text) as Record<string, unknown>
  } catch {
    if (!res.ok) {
      throw new Error(`${step} HTTP ${res.status}: ${text.slice(0, 200)}`)
    }
    throw new Error(`${step} returned non-JSON`)
  }
  if (!res.ok || !smartpayOk(data)) {
    throw new Error(`${step}: ${smartpayMessage(data)}`)
  }
  return data
}

/** Smartpay requires whole-number MNT amounts. */
function toMntAmount(amount: number, currency: string | null | undefined): number {
  const code = (currency ?? 'MNT').toUpperCase()
  const rounded = Math.round(Number(amount))
  if (code === 'MNT') return rounded
  if (code === 'USD') {
    const rate = Number(Deno.env.get('SMARTPAY_MNT_PER_USD') ?? '3500')
    return Math.round(rounded * rate)
  }
  throw new Error(
    `Smartpay only accepts MNT. Booking currency is ${code}. Set service currency to MNT or USD (converted via SMARTPAY_MNT_PER_USD).`,
  )
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { bookingId, amount, description, phone } = await req.json()

    if (!bookingId || amount == null) {
      return jsonResponse({ error: 'bookingId and amount are required' }, 400)
    }

    const username = Deno.env.get('SMARTPAY_USERNAME')?.trim()
    const password = Deno.env.get('SMARTPAY_PASSWORD')?.trim()
    const accountNumber = normalizeAccountNumber(
      Deno.env.get('SMARTPAY_ACCOUNT_NUMBER'),
    )
    if (!username || !password) {
      return jsonResponse({
        error:
          'Smartpay is not configured. Set SMARTPAY_USERNAME and SMARTPAY_PASSWORD in Supabase secrets.',
      }, 500)
    }
    if (!accountNumber) {
      return jsonResponse({
        error:
          'SMARTPAY_ACCOUNT_NUMBER must be your Smartpay merchant account: 8–12 digits only (no spaces or letters). Set it in Supabase → Edge Functions → Secrets.',
      }, 500)
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, serviceKey)

    const { data: booking, error: bookingError } = await supabase
      .from('bookings')
      .select('customer_id, coach_id, currency, amount_paid')
      .eq('id', bookingId)
      .single()

    if (bookingError || !booking) {
      return jsonResponse({ error: 'Booking not found' }, 404)
    }

    const bookingAmount = Number(booking.amount_paid ?? amount)
    let mntAmount: number
    try {
      mntAmount = toMntAmount(bookingAmount, booking.currency as string)
    } catch (currencyErr) {
      return jsonResponse({ error: String(currencyErr) }, 400)
    }

    if (mntAmount <= 0) {
      return jsonResponse({ error: 'Payment amount must be greater than zero' }, 400)
    }

    // Step 1: Authenticate with Smartpay
    const authRes = await fetch('https://apispay.esukh.mn/api/v1/merchant/auth', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password }),
    })
    let authData: Record<string, unknown>
    try {
      authData = await readSmartpayJson(authRes, 'Smartpay auth')
    } catch (authErr) {
      return jsonResponse({ error: String(authErr) }, 502)
    }
    const token = smartpayToken(authData)
    if (!token) {
      return jsonResponse({
        error: 'Smartpay authentication failed',
        message: 'No token in auth response',
        details: authData,
      }, 502)
    }

    // Step 2: Create invoice (amount always MNT)
    const itemDescription = description ?? `MyClub Booking ${bookingId}`
    const webhookUrl = `${supabaseUrl}/functions/v1/smartpay-webhook`
    const invoiceBody: Record<string, unknown> = {
      amount: mntAmount,
      description: itemDescription,
      returnUrl: `${supabaseUrl}/functions/v1/smartpay-return?bookingId=${bookingId}`,
      successCallback: webhookUrl,
      invoiceItems: [
        {
          amount: mntAmount,
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
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(invoiceBody),
    })
    let invoiceData: Record<string, unknown>
    try {
      invoiceData = await readSmartpayJson(invoiceRes, 'Smartpay invoice')
    } catch (invoiceErr) {
      return jsonResponse({
        error: 'Invoice creation failed',
        message: String(invoiceErr).replace(/^Smartpay invoice: /, ''),
        mntAmount,
      }, 502)
    }

    const invoiceId = invoiceData.invoiceId ?? invoiceData.InvoiceId ?? invoiceData.id
    const url = invoiceData.url ?? invoiceData.Url ?? invoiceData.paymentUrl
    if (!invoiceId || !url) {
      return jsonResponse({
        error: 'Invoice creation failed',
        message: 'Missing invoiceId or url in Smartpay response',
        details: invoiceData,
      }, 502)
    }

    await supabase.from('payments').insert({
      booking_id: bookingId,
      customer_id: booking.customer_id,
      coach_id: booking.coach_id,
      status: 'pending',
      amount: mntAmount,
      currency: 'MNT',
      provider_payment_id: String(invoiceId),
    })

    return jsonResponse({
      invoiceId,
      url,
      mntAmount,
      originalCurrency: booking.currency,
      originalAmount: bookingAmount,
    }, 200)
  } catch (err) {
    console.error('create-smartpay-invoice error:', err)
    return jsonResponse({ error: String(err) }, 500)
  }
})
