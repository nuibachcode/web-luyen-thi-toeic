FROM node:22-alpine
WORKDIR /app
COPY backend/api-gateway/package*.json ./
RUN npm install
COPY backend/api-gateway/tsconfig.json ./
COPY backend/api-gateway/src ./src
RUN npm run build
EXPOSE 4000
CMD ["npm", "start"]
