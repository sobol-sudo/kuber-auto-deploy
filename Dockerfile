# 🧱 Stage 1: Build
FROM node:18.14.2 AS builder

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate

COPY package*.json ./
COPY pnpm-lock.yaml ./
RUN pnpm install

COPY . .

RUN pnpm run build

# 🚀 Stage 2: Production runtime (Nginx)
FROM nginx:alpine AS runner

# Copy the built static assets from the previous stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy the nginx.conf config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
