#!/bin/bash

# Define the Docker Compose file location
COMPOSE_FILE="docker-compose.yml"

# Display help message
function show_help() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  build    Build the StudySpace Nginx Docker image"
    echo "  start    Start the StudySpace Nginx container"
    echo "  stop     Stop the StudySpace Nginx container"
    echo "  restart  Restart the StudySpace Nginx container"
    echo "  logs     Show StudySpace Nginx logs"
    echo "  clean    Stop and remove the StudySpace Nginx container"
    echo "  help     Display this help message"
}

# Check if Docker Compose file exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "Error: $COMPOSE_FILE not found!"
    exit 1
fi

# Handle script arguments
case "$1" in
    build)
        echo "Building the StudySpace Nginx Docker image..."
        docker compose -f "$COMPOSE_FILE" build
        ;;

    start)
        echo "Starting the StudySpace Nginx container..."
        docker compose -f "$COMPOSE_FILE" up -d
        ;;

    stop)
        echo "Stopping the StudySpace Nginx container..."
        docker compose -f "$COMPOSE_FILE" down
        ;;

    restart)
        echo "Restarting the StudySpace Nginx container..."
        docker compose -f "$COMPOSE_FILE" down
        docker compose -f "$COMPOSE_FILE" up -d
        ;;

    logs)
        echo "Displaying StudySpace Nginx logs..."
        docker compose -f "$COMPOSE_FILE" logs -f
        ;;

    clean)
        echo "Cleaning up: stopping and removing the StudySpace Nginx container..."
        docker compose -f "$COMPOSE_FILE" down -v
        ;;

    help)
        show_help
        ;;

    *)
        echo "Invalid option!"
        show_help
        ;;
esac