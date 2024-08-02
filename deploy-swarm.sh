#!/bin/bash
set -e

# Set environment variables
export SECRET_KEY=$(openssl rand -hex 32)

# Remove old stack and prune system
echo "Removing old stack..."
docker stack rm aethra || true
echo "Pruning system..."
docker system prune -af

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

# Update docker-stack.yml with new SECRET_KEY
sed -i "s/DJANGO_SECRET_KEY=.*/DJANGO_SECRET_KEY=$SECRET_KEY/" docker-stack.yml

# Deploy the stack
echo "Deploying the stack..."
docker stack deploy -c docker-stack.yml aethra

# Check service status
echo "Checking service status..."
docker service ls

# Check network status
echo "Checking network status..."
docker network ls | grep aethra_network

echo "Deployment complete!"