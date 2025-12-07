# ------------------------------
# 1. BUILDER STAGE
# ------------------------------
FROM node:20-alpine AS builder

# Аргумент порту (якщо не передали, буде 3001)
ARG APP_PORT=3001 
WORKDIR /app

# Встановлюємо залежності і білдимо
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build


# ------------------------------
# 2. PRODUCTION STAGE
# ------------------------------
FROM node:20-alpine AS production

# Налаштування порту
ARG APP_PORT=3001
ENV PORT=$APP_PORT

WORKDIR /app

# Встановлюємо тільки production залежності
COPY package*.json ./
RUN npm install --only=production

# Просто копіюємо зібраний проєкт
# Ніяких chown, ніяких USER - все працює під root
COPY --from=builder /app/dist ./dist

EXPOSE $APP_PORT

CMD ["npm", "run", "start:prod"]
