
FROM node:20-alpine AS builder


ARG APP_PORT=3001

WORKDIR /app


COPY package*.json ./


RUN npm install

COPY . .


RUN npm run build



FROM node:20-alpine AS production

ARG APP_PORT=3001

ENV PORT $APP_PORT

RUN addgroup -g 1000 nodejs \
    && adduser -u 1000 -G nodejs -s /bin/sh -D nodejs
USER nodejs

WORKDIR /app


COPY package*.json ./
RUN npm install --only=production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/.env ./

EXPOSE $APP_PORT


CMD ["npm", "run", "start:prod"]
