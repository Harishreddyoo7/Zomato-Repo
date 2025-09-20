# Use Node.js 16 slim as the base image
FROM node:16-alpine as builder

# Set the working directory
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:16-alpine as runner
WORKDIR /app

# Only copy the necessary files from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/build ./build
COPY --from=builder /app/server.js ./server.js

# Expose the port your Node.js server listens on
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
