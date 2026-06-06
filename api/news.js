const tabs = {
  business: 'business India finance',
  markets: 'stock market India',
  mutual_funds: 'mutual fund India SIP',
  tax_gst: 'income tax GST India',
  real_estate: 'real estate India property',
};

module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(204).end();
  }

  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const apiKey = process.env.NEWSDATA_API_KEY;
  if (!apiKey) {
    return res.status(503).json({ error: 'News service is not configured.' });
  }

  const tab = String(req.query.tab || 'business');
  const q = tabs[tab] || tabs.business;
  const size = Math.max(1, Math.min(Number(req.query.size) || 9, 50));
  const page = String(req.query.page || '').trim();

  const url = new URL('https://newsdata.io/api/1/news');
  url.searchParams.set('apikey', apiKey);
  url.searchParams.set('country', 'in');
  url.searchParams.set('language', 'en');
  url.searchParams.set('category', 'business');
  url.searchParams.set('q', q);
  url.searchParams.set('size', String(size));
  if (page) url.searchParams.set('page', page);

  try {
    const response = await fetch(url);
    const payload = await response.json();

    if (!response.ok || payload.status === 'error') {
      return res.status(502).json({ error: 'NewsData request failed.' });
    }

    res.setHeader('Cache-Control', 'no-store');
    return res.status(200).json(payload);
  } catch (_) {
    return res.status(502).json({ error: 'NewsData request failed.' });
  }
};
