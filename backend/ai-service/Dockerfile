FROM node:22-alpine
WORKDIR /app
COPY backend/ai-service/package*.json ./
RUN npm install
COPY backend/ai-service/tsconfig.json ./
COPY backend/ai-service/src ./src
RUN npm run build
EXPOSE 4005
CMD ["npm", "start"]
