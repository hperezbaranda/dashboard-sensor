.PHONY: help build run stop clean dev prod logs shell test

# Default target
help:
	@echo "Available commands:"
	@echo "  build     - Build the Docker image"
	@echo "  run       - Run the application in development mode"
	@echo "  prod      - Run the application in production mode with nginx"
	@echo "  stop      - Stop all running containers"
	@echo "  clean     - Remove containers and images"
	@echo "  logs      - Show application logs"
	@echo "  shell     - Open a shell in the running container"
	@echo "  test      - Run tests (if available)"

# Build Docker image
build:
	docker-compose build

# Run in development mode (with hot reload)
dev:
	docker-compose up --build

# Run in production mode (with nginx)
prod:
	docker-compose --profile production up --build -d

# Run the application
run: dev

# Stop all containers
stop:
	docker-compose down

# Clean up containers and images
clean:
	docker-compose down --rmi all --volumes --remove-orphans

# Show logs
logs:
	docker-compose logs -f dashboard-sensor

# Open shell in running container
shell:
	docker-compose exec dashboard-sensor /bin/bash

# Test the application
test:
	@echo "Testing application endpoints..."
	@curl -f http://localhost:8001/ || echo "Application not running on port 8001"
	@curl -f http://localhost:8001/current || echo "Current endpoint not responding"