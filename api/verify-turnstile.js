// Vercel Serverless Function: Cloudflare Turnstile Verification
export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ success: false, message: 'Method Not Allowed' });
  }

  try {
    let body = req.body;
    if (typeof body === 'string') {
      try {
        body = JSON.parse(body);
      } catch (e) {
        // body could be urlencoded or invalid json
      }
    }

    const token = body?.token;
    if (!token) {
      return res.status(400).json({ success: false, message: 'Thiếu token Turnstile' });
    }

    const secretKey = process.env.TURNSTILE_SECRET_KEY || '0x4AAAAAAAfquqzy1TLporrnh58amxmAE3Yw';
    const params = new URLSearchParams();
    params.append('secret', secretKey);
    params.append('response', token);

    const clientIp = req.headers['x-forwarded-for'] || req.headers['x-real-ip'];
    if (clientIp) {
      const ip = clientIp.split(',')[0].trim();
      params.append('remoteip', ip);
    }

    const cfRes = await fetch('https://challenges.cloudflare.com/turnstile/v0/siteverify', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: params.toString()
    });

    const data = await cfRes.json();
    return res.status(200).json(data);
  } catch (error) {
    console.error('Turnstile verification error:', error);
    return res.status(500).json({ success: false, message: error.message });
  }
}
