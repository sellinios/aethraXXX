#!/bin/bash
set -e

# Set environment variables
export SECRET_KEY=$(openssl rand -hex 32)
export DB_PASSWORD=$(openssl rand -hex 16)

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

# Update docker-stack.yml with new environment variables
sed -i "s/DJANGO_SECRET_KEY=.*/DJANGO_SECRET_KEY=$SECRET_KEY/" docker-stack.yml
sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$DB_PASSWORD/" docker-stack.yml

# Deploy the stack
echo "Deploying the stack..."
docker stack deploy -c docker-stack.yml aethra

# Wait for database to be ready
echo "Waiting for database to be ready..."
until docker exec $(docker ps -q -f name=aethra_db) pg_isready; do
    echo "Database is unavailable - sleeping"
    sleep 2
done

echo "Database is up - executing command"

# Check service status
echo "Checking service status..."
docker service ls

# Check network status
echo "Checking network status..."
docker network ls | grep aethra_network

echo "Deployment complete!"