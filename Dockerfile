# Use a smaller base image for the build stage
FROM node:18-alpine AS dev

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy only the package files first to leverage Docker layer caching
COPY package.json yarn.lock ./

# Install dependencies with Yarn in production mode
RUN yarn install --frozen-lockfile --production=false

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN yarn build

# RUN ls -la /usr/src/app/.next

# Create a new stage with a minimal runtime environment
FROM node:18-alpine AS builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy only the necessary artifacts from the dev stage
COPY --from=dev /usr/src/app/.next ./.next
COPY --from=dev /usr/src/app/package.json ./package.json
COPY --from=dev /usr/src/app/yarn.lock ./yarn.lock
COPY --from=dev /usr/src/app/public ./public

# Install only production dependencies
RUN yarn install --frozen-lockfile --production=true


FROM node:18-alpine AS production

# Set the working directory in the container
#WORKDIR /usr/src/app
WORKDIR /app

COPY . .

# Copy only the necessary artifacts from the builder stage
COPY --from=builder /usr/src/app/.next ./.next
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/package.json ./package.json
COPY --from=builder /usr/src/app/public ./public


# Expose the port that the application will run on
EXPOSE 3000

# Command to run the Next.js application
CMD ["yarn", "start"]
