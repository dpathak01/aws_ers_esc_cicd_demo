# ============================
# 1️⃣ Builder Stage
# ============================
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json / package-lock.json first (better caching)
COPY package*.json ./

# Install all dependencies (including devDeps needed to build TS)
RUN npm install

# Copy source code
COPY . .

# Build TypeScript -> JavaScript
RUN npm run build


# ============================
# 2️⃣ Runtime Stage (smaller)
# ============================
FROM node:18-alpine AS runner

WORKDIR /app

# Copy ONLY required output files
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# Expose the port used by your Node.js app
EXPOSE 3000

# Start the application
CMD ["node", "dist/index.js"]
