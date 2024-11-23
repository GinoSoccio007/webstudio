FROM node:20

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm
RUN npm install -g pnpm

# Copy the entire project
COPY . .

# Install all dependencies
RUN pnpm install

# Add verbose logging to see what's happening
RUN pnpm exec ls -la
RUN pnpm --filter builder exec ls -la

# Try to build with more verbosity
RUN pnpm --filter builder build --verbose

EXPOSE 3000

CMD ["pnpm", "--filter", "builder", "start"]
