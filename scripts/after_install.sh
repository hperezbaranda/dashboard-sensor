#!/bin/bash

set -e

echo "Starting AfterInstall phase..."

cd /var/www/laravel-api

# Restore .env if exists
if [ -f /tmp/laravel-env-backup ]; then
    cp /tmp/laravel-env-backup .env
    rm /tmp/laravel-env-backup
fi

# Restore storage directory
if [ -d /tmp/laravel-storage-backup ]; then
    cp -r /tmp/laravel-storage-backup/* storage/
    rm -rf /tmp/laravel-storage-backup
fi

# Set proper permissions
chown -R www-data:www-data /var/www/laravel-api
chmod -R 755 /var/www/laravel-api/storage
chmod -R 755 /var/www/laravel-api/bootstrap/cache

# Build Docker image
docker-compose build

echo "AfterInstall completed successfully"