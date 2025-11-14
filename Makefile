.PHONY: help build run stop clean dev prod logs shell test test-quick test-cov test-watch

# Default target
help:
	@echo "Available commands:"
	@echo "  build       - Build the Docker image"
	@echo "  run         - Run the application in development mode"
	@echo "  prod        - Run the application in production mode with nginx"
	@echo "  stop        - Stop all running containers"
	@echo "  clean       - Remove containers and images"
	@echo "  logs        - Show application logs"
	@echo "  shell       - Open a shell in the running container"
	@echo "  test        - Run all tests with coverage"
	@echo "  test-quick  - Run tests without coverage"
	@echo "  test-cov    - Run tests with HTML coverage report"
	@echo "  test-watch  - Run tests in watch mode"

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

# Run all tests with coverage
test:
	@./run-tests.sh

# Run quick tests without coverage
test-quick:
	@./run-tests.sh quick

# Run tests with HTML coverage report
test-cov:
	@./run-tests.sh coverage

# Run tests in watch mode (requires pytest-watch)
test-watch:
	@./run-tests.sh watch

# Verify application endpoints (for Docker)
verify:
	@echo "Testing application endpoints..."
	@curl -f http://localhost:8000/ || echo "Application not running on port 8000"
	@curl -f http://localhost:8000/current || echo "Current endpoint not responding"