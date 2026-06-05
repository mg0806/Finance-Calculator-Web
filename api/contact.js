const nodemailer = require('nodemailer');

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function readBody(req) {
  if (!req.body) return {};
  if (typeof req.body === 'object') return req.body;
  try {
    return JSON.parse(req.body);
  } catch (_) {
    return {};
  }
}

function clean(value, maxLength) {
  return String(value || '').trim().slice(0, maxLength);
}

module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(204).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const gmailUser = process.env.GMAIL_USER;
  const gmailAppPassword = process.env.GMAIL_APP_PASSWORD;
  const contactTo = process.env.CONTACT_TO || gmailUser;

  if (!gmailUser || !gmailAppPassword || !contactTo) {
    return res.status(500).json({ error: 'Email service is not configured.' });
  }

  const body = readBody(req);
  const name = clean(body.name, 100);
  const email = clean(body.email, 160);
  const message = clean(body.message, 4000);

  if (!name || !emailPattern.test(email) || !message) {
    return res.status(400).json({ error: 'Please provide a valid name, email, and message.' });
  }

  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: gmailUser,
      pass: gmailAppPassword,
    },
  });

  await transporter.sendMail({
    from: `"YieldWise Contact" <${gmailUser}>`,
    to: contactTo,
    replyTo: email,
    subject: `YieldWise contact from ${name}`,
    text: [
      `Name: ${name}`,
      `Email: ${email}`,
      '',
      message,
    ].join('\n'),
    html: `
      <h2>New YieldWise contact message</h2>
      <p><strong>Name:</strong> ${escapeHtml(name)}</p>
      <p><strong>Email:</strong> ${escapeHtml(email)}</p>
      <p><strong>Message:</strong></p>
      <p>${escapeHtml(message).replace(/\n/g, '<br>')}</p>
    `,
  });

  return res.status(200).json({ ok: true });
};

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}
