#!/usr/bin/env bash

set -e
set -x

echo "=== Starting prestart script ==="
echo "Current time: $(date)"
echo "Environment: $ENVIRONMENT"
echo "Database: $POSTGRES_SERVER:$POSTGRES_PORT/$POSTGRES_DB"

echo "=== Step 1: Waiting for database ==="
python app/backend_pre_start.py
if [ $? -eq 0 ]; then
    echo "✓ Database connection successful"
else
    echo "✗ Database connection failed"
    exit 1
fi

echo "=== Step 2: Running migrations ==="
alembic upgrade head
if [ $? -eq 0 ]; then
    echo "✓ Migrations completed successfully"
else
    echo "✗ Migrations failed"
    exit 2
fi

echo "=== Step 3: Creating initial data ==="
python app/initial_data.py
if [ $? -eq 0 ]; then
    echo "✓ Initial data creation successful"
else
    echo "✗ Initial data creation failed"
    exit 3
fi

echo "=== Prestart script completed successfully ==="