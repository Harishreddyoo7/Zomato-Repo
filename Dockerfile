# Use Node.js 16 slim as the base image
FROM node:16-alpine as builder

# Set the working directory
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:16-alpine AS runner

WORKDIR /app

COPY package*.json ./
RUN npm install --only=production

# Copy the build folder if your app serves it via Express or similar
COPY --from=builder /app/build ./build

EXPOSE 3000

CMD ["npm", "start"]
