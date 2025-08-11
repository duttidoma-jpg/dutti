import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { createServer } from 'http';
import { Server } from 'socket.io';
import { Telegraf } from 'telegraf';
import { IncidentInputSchema } from '@dutti/shared';

const PORT = process.env.PORT || 8080;
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || '';
const TELEGRAM_WEBAPP_URL = process.env.TELEGRAM_WEBAPP_URL || '';

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/health', (_req, res) => {
  res.json({ ok: true });
});

const httpServer = createServer(app);
const io = new Server(httpServer, { path: '/ws', cors: { origin: '*' } });

const WEBHOOK_SHARED_SECRET = process.env.WEBHOOK_SHARED_SECRET || '';

app.post('/api/ingest/webhook', (req, res) => {
  if (req.query.secret !== WEBHOOK_SHARED_SECRET) {
    return res.status(403).json({ error: 'forbidden' });
  }
  const payload = req.body;
  try {
    const incidents = Array.isArray(payload)
      ? payload.map((p: unknown) => IncidentInputSchema.parse(p))
      : [IncidentInputSchema.parse(payload)];
    io.emit('incidents:new', incidents);
    res.json({ received: incidents.length });
  } catch (err) {
    res.status(400).json({ error: (err as Error).message });
  }
});

if (TELEGRAM_BOT_TOKEN) {
  const bot = new Telegraf(TELEGRAM_BOT_TOKEN);

  bot.start((ctx) => {
    if (TELEGRAM_WEBAPP_URL) {
      ctx.reply('Open Radar', {
        reply_markup: {
          inline_keyboard: [
            [{ text: 'Open Radar', web_app: { url: TELEGRAM_WEBAPP_URL } }],
          ],
        },
      });
    } else {
      ctx.reply('Radar coming soon');
    }
  });

  bot.launch().then(() => console.log('Bot started'));
  const stopBot = () => bot.stop();
  process.once('SIGINT', stopBot);
  process.once('SIGTERM', stopBot);
} else {
  console.warn('TELEGRAM_BOT_TOKEN not set, bot disabled');
}

const shutdown = () => {
  io.close();
  httpServer.close(() => process.exit(0));
};
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);

httpServer.listen(PORT, () => {
  console.log(`API server listening on ${PORT}`);
});
