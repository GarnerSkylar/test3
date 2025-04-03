# Dockerfile for Next.js Dev Environment
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy all source files
COPY . .

# Expose development port
EXPOSE 3000

# Start dev server
CMD ["npx", "next", "dev", "-p", "3000", "-H", "0.0.0.0"]
