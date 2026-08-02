FROM node:22-alpine
WORKDIR /app
COPY backend/exam-service/package*.json ./
RUN npm install
COPY backend/exam-service/prisma ./prisma
RUN npx prisma generate
COPY backend/exam-service/tsconfig.json ./
COPY backend/exam-service/src ./src
RUN npm run build
EXPOSE 4002
CMD ["sh", "-c", "npx prisma db push --accept-data-loss && npm start"]
