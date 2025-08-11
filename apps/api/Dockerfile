FROM node:20-alpine AS build
WORKDIR /repo

# copy workspace files
COPY pnpm-workspace.yaml package.json tsconfig.base.json ./
COPY packages ./packages
COPY apps/api/package.json apps/api/tsconfig.json apps/api/src ./apps/api/

RUN corepack enable \
  && pnpm install --filter api... --prod=false \
  && pnpm -F @dutti/shared build \
  && pnpm -F api build

FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production

COPY --from=build /repo/apps/api/dist ./dist
COPY --from=build /repo/apps/api/package.json ./package.json
COPY --from=build /repo/apps/api/node_modules ./node_modules

CMD ["node", "dist/index.js"]

