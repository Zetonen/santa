# --------------------
# 1. BUILDER STAGE (Сборка)
# --------------------
FROM node:20-alpine AS builder

# ARG должен быть определен в каждой стадии, где он используется.
ARG APP_PORT=3001 

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем и устанавливаем все зависимости (включая devDependencies)
COPY package*.json ./
RUN npm install

# Копируем остальной код и запускаем сборку NestJS
COPY . .
RUN npm run build


# --------------------
# 2. PRODUCTION STAGE (Запуск)
# --------------------
FROM node:20-alpine AS production

# 1. Определение порта 3001
ARG APP_PORT=3001
# Устанавливаем переменную окружения для NestJS
ENV PORT $APP_PORT

# 2. ИСПРАВЛЕНИЕ ОШИБКИ: Создаем не-root пользователя 'app' и группу 'app' (надежный синтаксис для Alpine)
# -D означает, что не будет создано домашнего каталога
RUN adduser -D -g 'app' 'app'

# Переключаемся на безопасного пользователя
USER app 

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем и устанавливаем ТОЛЬКО production-зависимости
COPY package*.json ./
RUN npm install --only=production

# Копируем собранный код (dist) из BUILDER STAGE
COPY --from=builder /app/dist ./dist

# Документируем порт 3001
EXPOSE $APP_PORT

# Запуск приложения с помощью скрипта start:prod
CMD ["npm", "run", "start:prod"]
