FROM node:22-bookworm-slim
WORKDIR /app
ENV NODE_ENV=production PORT=10000 DATA_DIR=/var/data COOKIE_SECURE=1
COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund && npm cache clean --force
COPY server.js ./
COPY public ./public
RUN mkdir -p /var/data && chown -R node:node /app /var/data
USER node
EXPOSE 10000
CMD ["node", "server.js"]
