# === Build Stage ===
FROM node:16-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build


# === Production Stage ===
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Copy built app and package files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/build ./build

# Install dependencies (likely needed for `npm start`)
RUN npm install --only=production

# Expose the port your app listens on
EXPOSE 3000

# Start the Node.js server
CMD ["npm", "start"]
