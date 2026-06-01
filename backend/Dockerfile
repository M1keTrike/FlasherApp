# ---------- Etapa de build ----------
FROM node:22-alpine AS build

WORKDIR /app

# Instala TODAS las dependencias (incluidas las de desarrollo) para compilar.
COPY package*.json ./
RUN npm ci

# Copia el código y compila a dist/.
COPY . .
RUN npm run build

# ---------- Etapa de runtime ----------
FROM node:22-alpine AS runtime

WORKDIR /app
ENV NODE_ENV=production

# Solo dependencias de producción.
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Artefactos compilados.
COPY --from=build /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/main.js"]
