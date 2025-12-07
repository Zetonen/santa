# --------------------
# 1. BUILDER STAGE (Збірка) - залишається без змін
# --------------------
FROM node:20-alpine AS builder

ARG APP_PORT=3001 

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


# --------------------
# 2. PRODUCTION STAGE (Запуск)
# --------------------
FROM node:20-alpine AS production

# 1. Определение порта 3001
ARG APP_PORT=3001
ENV PORT $APP_PORT

# 2. Встановлюємо робочу директорію
WORKDIR /app

# 3. Копіюємо package.json та встановлюємо тільки production-залежності
# ЦЕЙ КРОК ВИКОНУЄТЬСЯ ПІД КОРИСТУВАЧЕМ ROOT
COPY package*.json ./
RUN npm install --only=production

# 4. Копіюємо зібраний код (dist)
COPY --from=builder /app/dist ./dist

# 5. КОРЕКЦІЯ ДОЗВОЛІВ:
# Ми змінюємо власника всіх файлів на стандартного користувача 'node',
# щоб він міг їх читати та виконувати.
RUN chown -R node:node /app 

# 6. Переключаємося на стандартного, не-root користувача 'node'
USER node 

# 7. Документуємо порт
EXPOSE $APP_PORT

# 8. Запуск програми
CMD ["npm", "run", "start:prod"]
