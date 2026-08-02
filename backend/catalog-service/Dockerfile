FROM node:22-alpine
WORKDIR /app
COPY backend/catalog-service/package*.json ./
RUN npm install
COPY backend/catalog-service/prisma ./prisma
RUN npx prisma generate
COPY backend/catalog-service/tsconfig.json ./
COPY backend/catalog-service/src ./src
RUN npm run build
EXPOSE 4003
CMD ["sh", "-c", "(npx prisma db push --accept-data-loss || true) && npm start"]
