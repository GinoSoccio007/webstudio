FROM node:20-slim

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Install dependencies first to leverage Docker cache
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/*/package.json ./packages/
RUN pnpm install --frozen-lockfile

# Copy the rest of the application
COPY . .

# Build the application
RUN pnpm build

# Expose the port
EXPOSE 3000

# Start the application
CMD ["pnpm", "start"]
