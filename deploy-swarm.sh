#!/bin/bash

# deploy-swarm.sh

clear
set -e

# Set environment variables
export SECRET_KEY=$(openssl rand -hex 32)

# Remove old stack and prune system
echo "Removing old stack..."
docker stack rm aethra || true
echo "Waiting for services to stop..."
sleep 10  # Wait for services to stop
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
sed -i "s/DJANGO_SECRET_KEY: .*/DJANGO_SECRET_KEY: '$SECRET_KEY'/" docker-stack.yml

# Deploy the stack
echo "Deploying the stack..."
docker stack deploy -c docker-stack.yml aethra

# Wait for services to start
echo "Waiting for services to start..."
sleep 20  # Adjust as necessary

# Apply migrations and collect static files
echo "Applying database migrations and collecting static files..."
# Get the ID of one of the backend containers
BACKEND_CONTAINER_ID=$(docker ps --filter "name=aethra_backend" -q | head -n 1)

if [ -n "$BACKEND_CONTAINER_ID" ]; then
    docker exec -it "$BACKEND_CONTAINER_ID" python manage.py migrate --noinput
    docker exec -it "$BACKEND_CONTAINER_ID" python manage.py collectstatic --noinput
else
    echo "Error: Could not find backend container to apply migrations and collect static files."
fi

# Check service status
echo "Checking service status..."
docker service ls

# Check network status
echo "Checking network status..."
docker network ls | grep aethra_network

echo "Deployment complete!"
