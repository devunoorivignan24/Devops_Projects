# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy all code
COPY . .

# Expose port the app uses (change if your app uses a different port)
EXPOSE 3000

# Default command to run your app — adjust if your entrypoint is different
CMD ["node", "app.js"]
