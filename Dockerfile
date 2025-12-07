# --------------------
# 2. PRODUCTION STAGE (Запуск)
# --------------------
FROM node:20-alpine AS production

ARG APP_PORT=3001
ENV PORT $APP_PORT

# 1. Встановлюємо робочу директорію
WORKDIR /app

# 2. Копіюємо package.json
COPY package*.json ./

# 3. Встановлюємо тільки production-залежності (під ROOT)
# RUN npm install --only=production (Виконується під root, щоб уникнути помилок)
RUN npm install --only=production

# 4. КОРЕКЦІЯ ДОЗВОЛІВ:
# Ми змінюємо власника всієї теки /app на користувача 'node'. 
# Якщо тут зависає, то проблема в кількості файлів.
RUN chown -R node:node /app 

# 5. Копіюємо зібраний код (dist)
COPY --from=builder /app/dist ./dist

# 6. Переключаємося на стандартного, не-root користувача 'node'
USER node 

# 7. Документуємо порт
EXPOSE $APP_PORT

# 8. Запуск програми
CMD ["npm", "run", "start:prod"]
