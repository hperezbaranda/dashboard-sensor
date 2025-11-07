#!/bin/bash

set -e

echo "Starting ApplicationStart phase..."

cd /var/www/laravel-api

# Start the application with docker-compose
docker-compose up -d

# Wait for container to be ready
sleep 10

echo "ApplicationStart completed successfully"