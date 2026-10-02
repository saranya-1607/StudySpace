#!/bin/bash

# Navigate to the backend directory
cd backend

# Build the Docker image for the backend
echo "Building the backend Docker image..."
docker build -t studyspace-backend .

# Run the Docker container for the backend
echo "Running the backend container..."
docker run -d --name studyspace-backend -p 5000:5000 studyspace-backend

# Show running containers
docker ps
