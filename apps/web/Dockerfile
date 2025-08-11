FROM node:20-alpine AS build
WORKDIR /repo

COPY pnpm-workspace.yaml package.json tsconfig.base.json ./
COPY packages ./packages
COPY apps/web/package.json apps/web/tsconfig.json apps/web/vite.config.ts apps/web/src apps/web/index.html ./apps/web/

RUN corepack enable \
  && pnpm install --filter web... --prod=false \
  && pnpm -F web build

FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production

COPY --from=build /repo/apps/web/dist ./dist
COPY --from=build /repo/apps/web/package.json ./package.json
COPY --from=build /repo/apps/web/node_modules ./node_modules

EXPOSE 3000
CMD ["node_modules/.bin/vite", "preview", "--host", "0.0.0.0", "--port", "3000"]

