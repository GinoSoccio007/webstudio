FROM node:20-slim

WORKDIR /app

# Install build essentials and git for native dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm
RUN npm install -g pnpm

# Copy package files and patches first
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY patches/ ./patches/
COPY packages/ ./packages/

# Install dependencies with build dependencies
RUN pnpm install --frozen-lockfile

# Copy the rest of the application
COPY . .

# Build the application - using the specific builder script
RUN pnpm run build

# Expose the port
EXPOSE 3000

# Set the environment to production
ENV NODE_ENV=production

# Start the application using the builder
CMD ["pnpm", "--filter", "builder", "start"]
