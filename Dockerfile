# ------------------------------
# 1. BUILDER STAGE (Збірка коду)
# ------------------------------
FROM node:20-alpine AS builder

ARG APP_PORT=3001 
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build


# ------------------------------
# 2. PRODUCTION STAGE (Запуск)
# ------------------------------
# Це фінальна стадія
FROM node:20-alpine AS production

ARG APP_PORT=3001
ENV PORT $APP_PORT

WORKDIR /app

COPY package*.json ./
RUN npm install --only=production


COPY --from=builder /app/dist ./dist

RUN chown -R node:node /app 

USER node 

EXPOSE $APP_PORT

CMD ["npm", "run", "start:prod"]
