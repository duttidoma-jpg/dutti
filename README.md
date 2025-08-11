# dutti

Monorepo scaffold for a Telegram-based UAV incident radar. It includes:

- `apps/api` – Express server with Socket.IO and a stub Telegram bot.
- `apps/web` – React + Vite WebApp that connects to the realtime API.
- `packages/shared` – Shared Zod schemas and types.

## Getting Started

1. Install dependencies:
   ```bash
   pnpm install
   ```
2. Copy `.env.example` to `.env` and adjust values. Be sure to supply a fresh `TELEGRAM_BOT_TOKEN` from [BotFather](https://t.me/BotFather) and configure `VITE_WS_URL` for the WebSocket endpoint.
3. Start development servers:
   ```bash
   pnpm dev:api # in one terminal
   pnpm dev:web # in another terminal
   ```
4. Or run the stack via Docker:
   ```bash
   docker-compose up --build
   ```

The API provides `/api/health` and `/api/ingest/webhook` endpoints. The WebApp connects to the WebSocket namespace at `/ws` and logs incoming incident events.

This is an early foundation; major features from the project brief still need implementation.
