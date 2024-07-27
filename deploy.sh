#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Enable debug mode
set -x

# Docker Hub username
DOCKER_USERNAME="sellinios"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
command_exists docker || { echo "Docker is not installed. Please install Docker and try again."; exit 1; }
command_exists microk8s || { echo "MicroK8s is not installed. Please install MicroK8s and try again."; exit 1; }
command_exists jq || { echo "jq is not installed. Installing jq..."; sudo apt-get update && sudo apt-get install -y jq; }

# Function to extract image names from production.yaml
extract_images() {
    echo "Extracting image names from production.yaml:"
    grep 'image:' production.yaml | awk '{print $2}'
}

# Function to login to Docker
docker_login() {
    echo "Logging in to Docker Hub..."
    read -s -p "Enter your Docker Hub password: " docker_password
    echo
    echo "$docker_password" | sudo docker login --username "$DOCKER_USERNAME" --password-stdin
}

# Function to build and push Docker images
build_and_push_images() {
    local images=$(extract_images)
    echo "Found images: $images"
    for image in $images; do
        local name=$(echo $image | cut -d'/' -f2 | cut -d':' -f1)
        local dir=""
        if [[ $name == *"backend"* ]]; then
            dir="./backend"
        elif [[ $name == *"frontend"* ]]; then
            dir="./frontend"
        else
            echo "Unknown image: $image"
            continue
        fi
        echo "Building $image..."
        sudo docker build -t "$image" "$dir" || { echo "Failed to build $image"; exit 1; }
        echo "Pushing $image..."
        sudo docker push "$image" || { echo "Failed to push $image. Attempting to log in..."; docker_login; sudo docker push "$image" || { echo "Failed to push $image after login"; exit 1; } }
    done
}

# Function to generate a random string
generate_random_string() {
    openssl rand -base64 32 | tr -d /=+ | cut -c -32
}

# Function to generate database URL
generate_db_url() {
    local db_user=$(generate_random_string)
    local db_pass=$(generate_random_string)
    local db_name="aethra_db"
    local db_host="postgres"  # Changed to match the service name in Kubernetes
    echo "postgresql://${db_user}:${db_pass}@${db_host}:5432/${db_name}"
}

# Function to update secrets in production.yaml
update_secrets() {
    echo "Updating secrets in production.yaml..."

    # Check if secrets already exist
    local current_db_url=$(grep 'database-url:' production.yaml | awk '{print $2}' | tr -d '"')
    local current_secret_key=$(grep 'secret-key:' production.yaml | awk '{print $2}' | tr -d '"')

    # Generate new secrets only if they don't exist or are the default values
    if [[ "$current_db_url" == "postgresql://user:password@your-db-host/dbname" || -z "$current_db_url" ]]; then
        local db_url=$(generate_db_url)
        sed -i "s|database-url: .*|database-url: \"$db_url\"|g" production.yaml
        echo "New database URL generated and updated in production.yaml"
    else
        echo "Existing database URL found in production.yaml. Skipping update."
    fi

    if [[ "$current_secret_key" == "your-django-secret-key" || -z "$current_secret_key" ]]; then
        local secret_key=$(generate_random_string)
        sed -i "s|secret-key: .*|secret-key: \"$secret_key\"|g" production.yaml
        echo "New Django secret key generated and updated in production.yaml"
    else
        echo "Existing Django secret key found in production.yaml. Skipping update."
    fi
}

# Function to clean up old ReplicaSets
cleanup_old_replicasets() {
    echo "Cleaning up old ReplicaSets..."
    
    old_replicasets=$(microk8s kubectl get rs -n aethra -o json | jq -r '.items[] | select(.spec.replicas == 0) | .metadata.name')

    for rs in $old_replicasets; do
        echo "Deleting ReplicaSet $rs"
        microk8s kubectl delete rs $rs -n aethra
    done
}

# Function to clean up Docker images
cleanup_docker_images() {
    echo "Cleaning up unused Docker images..."
    sudo docker image prune -a -f --filter "until=24h"
}

# Main deployment function
deploy() {
    echo "Starting deployment process..."

    # Print contents of production.yaml for debugging
    echo "Contents of production.yaml:"
    cat production.yaml

    build_and_push_images
    update_secrets

    echo "Applying Kubernetes configuration..."
    microk8s kubectl apply -f production.yaml || { echo "Failed to apply Kubernetes configuration"; exit 1; }

    echo "Waiting for deployment to stabilize..."
    sleep 30  # Wait for 30 seconds to allow the deployment to progress

    echo "Cleaning up old resources..."
    cleanup_old_replicasets
    cleanup_docker_images

    echo "Deployment completed successfully!"
}

# Run the deployment
deploy

# Check the status of the deployment
echo "Checking deployment status..."
microk8s kubectl get all -n aethra
microk8s kubectl get ingress -n aethra