FROM node:20-alpine AS deps_stage


COPY --from=deps_stage /app/dist ./dist

ARG APP_PORT=3001
ENV PORT $APP_PORT

WORKDIR /app

COPY package*.json ./


RUN npm install --only=production


RUN chown -R node:node /app 

COPY --from=builder /app/dist ./dist

USER node 

EXPOSE $APP_PORT

CMD ["npm", "run", "start:prod"]
