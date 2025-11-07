#!/bin/bash

set -e

echo "Starting ValidateService phase..."

# Wait a bit for the application to fully start
sleep 5

# Check if container is running
if ! docker-compose ps | grep -q "Up"; then
    echo "ERROR: Container is not running"
    exit 1
fi

# Health check - test if application responds
MAX_RETRIES=10
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -f http://localhost:80/ > /dev/null 2>&1; then
        echo "Application is responding successfully"
        echo "ValidateService completed successfully"
        exit 0
    fi
    
    echo "Waiting for application to respond... ($((RETRY_COUNT+1))/$MAX_RETRIES)"
    sleep 3
    RETRY_COUNT=$((RETRY_COUNT+1))
done

echo "ERROR: Application did not respond within expected time"
exit 1