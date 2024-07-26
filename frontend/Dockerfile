# Stage 1: Build the application
FROM node:22.4 AS build

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy project files and build
COPY . .
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginx:1.27-alpine

# Copy built files from the build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Optionally copy ads.txt if it exists
COPY ads.txt /usr/share/nginx/html/ads.txt

# Expose ports
EXPOSE 80
EXPOSE 443

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
