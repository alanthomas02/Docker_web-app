#install Dependencies
FROM node:20-alpine as Build
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev

#Final runtime image
FROM node:20-alpine 
WORKDIR /app
ENV NODE_ENV=production
COPY --from=Build /app/node_modules ./node_modules
COPY . .
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "app.js"]