#!/bin/bash

set -e

echo "Starting ApplicationStop phase..."

# Stop the application gracefully
if [ -f /var/www/laravel-api/docker-compose.yml ]; then
    cd /var/www/laravel-api
    docker-compose down || true
fi

echo "ApplicationStop completed successfully"
