// @ts-nocheck
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'

/**
 * Browser returnUrl after Smartpay payment.
 * Smartpay redirects here with ?secureId=<UUID>
 * Shows a simple page telling the user to return to the app.
 */
serve(async (req) => {
  const url = new URL(req.url)
  const bookingId = url.searchParams.get('bookingId') ?? ''

  const html = `<!DOCTYPE html>
<html lang="mn">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Tennis Hub — Төлбөр</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: #F4F6F4;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 24px;
    }
    .card {
      background: white;
      border-radius: 20px;
      padding: 40px 32px;
      max-width: 400px;
      width: 100%;
      text-align: center;
      box-shadow: 0 4px 24px rgba(0,0,0,0.08);
    }
    .icon { font-size: 64px; margin-bottom: 16px; }
    h1 { color: #2D6A4F; font-size: 22px; margin-bottom: 8px; }
    p { color: #666; font-size: 15px; line-height: 1.5; margin-bottom: 24px; }
    a.btn {
      display: inline-block;
      background: #2D6A4F;
      color: white;
      text-decoration: none;
      padding: 14px 32px;
      border-radius: 14px;
      font-size: 16px;
      font-weight: 600;
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="icon">✅</div>
    <h1>Төлбөр амжилттай!</h1>
    <p>Таны төлбөр хүлээн авагдлаа.<br/>Tennis Hub апп руу буцна уу.</p>
    <a href="myclub:///home" class="btn">Апп руу буцах</a>
  </div>
</body>
</html>`

  return new Response(html, {
    status: 200,
    headers: { 'Content-Type': 'text/html; charset=utf-8' },
  })
})
