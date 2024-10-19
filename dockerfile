# Stage 1
FROM node:20.18.0-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

RUN npm run build

# Stage 2
FROM node:20.18.0-alpine AS runner

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --production

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/next.config.mjs ./

EXPOSE 3000

CMD ["npm", "run", "start"]