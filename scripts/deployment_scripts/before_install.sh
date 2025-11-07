#!/bin/bash
# scripts/before_install.sh

set -e

echo "Starting BeforeInstall phase..."

# Stop existing containers if running
if [ -f /var/www/laravel-api/docker-compose.yml ]; then
    cd /var/www/laravel-api
    docker-compose down || true
fi

# Clean up old deployment files (keep logs and storage)
if [ -d /var/www/laravel-api ]; then
    # Backup storage directory
    if [ -d /var/www/laravel-api/storage ]; then
        cp -r /var/www/laravel-api/storage /tmp/laravel-storage-backup
    fi
    
    # Backup .env file
    if [ -f /var/www/laravel-api/.env ]; then
        cp /var/www/laravel-api/.env /tmp/laravel-env-backup
    fi
    
    # Remove old files except .env
    find /var/www/laravel-api -mindepth 1 ! -name '.env' -delete || true
fi

# Create deployment directory
mkdir -p /var/www/laravel-api

echo "BeforeInstall completed successfully"