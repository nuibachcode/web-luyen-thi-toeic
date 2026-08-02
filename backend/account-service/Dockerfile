FROM node:22-alpine
WORKDIR /app
COPY backend/account-service/package*.json ./
RUN npm install
COPY backend/account-service/prisma ./prisma
RUN npx prisma generate
COPY backend/account-service/tsconfig.json ./
COPY backend/account-service/src ./src
RUN npm run build
EXPOSE 4001
CMD ["sh", "-c", "(npx prisma db push --accept-data-loss || true) && npm start"]
