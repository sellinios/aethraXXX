#!/bin/bash

# Set environment variables
export SECRET_KEY=$(openssl rand -hex 32)
export DB_PASSWORD=$(openssl rand -hex 16)

# Initialize Docker Swarm if not already initialized
if [ "$(docker info --format '{{.Swarm.LocalNodeState}}')" == "inactive" ]; then
    echo "Initializing Docker Swarm..."
    docker swarm init
fi

# Build images
echo "Building backend image..."
docker build -t aethra_backend:latest ./backend
echo "Building frontend image..."
docker build -t aethra_frontend:latest ./frontend

# Deploy the stack
echo "Deploying the stack..."
docker stack deploy -c docker-stack.yml aethra

# Wait for services to start
echo "Waiting for services to start..."
sleep 30

# Check service status
echo "Checking service status..."
docker service ls

# Check network status
echo "Checking network status..."
docker network ls | grep aethra_network

echo "Deployment complete!"