#!/bin/bash

# Navigate to the root directory where docker-compose.yml is located
cd "$(dirname "$0")"

# Stop and remove any existing containers
echo "Stopping and removing any existing containers..."
docker compose down

# Build and start all StudySpace services
echo "Building and starting all StudySpace services..."
docker compose up --build -d

# Check running containers
echo "Checking running containers..."
docker ps