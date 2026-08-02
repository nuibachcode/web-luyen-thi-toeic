FROM node:22-alpine
WORKDIR /app
COPY backend/analytics-service/package*.json ./
RUN npm install
COPY backend/analytics-service/prisma ./prisma
RUN npx prisma generate
COPY backend/analytics-service/tsconfig.json ./
COPY backend/analytics-service/src ./src
RUN npm run build
EXPOSE 4004
CMD ["sh", "-c", "npx prisma db push --accept-data-loss && npm start"]
