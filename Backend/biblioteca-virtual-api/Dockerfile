# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm ci

# Copiar el código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Stage 2: Runtime
FROM node:18-alpine

WORKDIR /app

# Variables de entorno
ENV NODE_ENV=production

# Copiar dependencias de producción
COPY package*.json ./
RUN npm ci --only=production

# Copiar la aplicación compilada desde el builder
COPY --from=builder /app/dist ./dist

# Exponer el puerto
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Comando para iniciar la aplicación
CMD ["node", "dist/main.js"]
