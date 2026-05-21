FROM node:20-alpine AS builder

WORKDIR /squadra-web-back

COPY package*.json ./
RUN npm ci

COPY prisma ./prisma/
RUN npx prisma generate

COPY . .

RUN npm run build


FROM node:20-alpine AS runner
WORKDIR /squadra-web-back

ENV NODE_ENV="production"

COPY package*.json ./
RUN npm ci --omit=dev

COPY prisma ./prisma/
RUN npx prisma generate

COPY --from=builder /squadra-web-back/dist ./dist

USER node

EXPOSE 3000

CMD ["node", "dist/index.js"]
