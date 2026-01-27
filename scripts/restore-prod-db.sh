#!/bin/bash
# Production Database Restore Script
# Usage: ./restore-prod-db.sh <backup_file.sql.gz>

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <backup_file.sql.gz>"
    echo ""
    echo "Available backups:"
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
    ls -lh "${PROJECT_DIR}/backups/rsvp_prod_"*.sql.gz 2>/dev/null || echo "  No backups found"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Load environment variables from .env file
if [ -f "${PROJECT_DIR}/.env" ]; then
    export $(grep -v '^#' "${PROJECT_DIR}/.env" | xargs)
fi

POSTGRES_DB="${POSTGRES_DB:-rsvp}"
POSTGRES_USER="${POSTGRES_USER:-rsvp}"

echo "WARNING: This will overwrite ALL data in the production database!"
echo "Backup file: $BACKUP_FILE"
echo ""
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Restore cancelled."
    exit 0
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting restore..."

# Drop and recreate database
echo "$(date '+%Y-%m-%d %H:%M:%S') - Dropping existing database..."
docker exec rsvp-prod-db-1 psql -U "$POSTGRES_USER" -d postgres -c "DROP DATABASE IF EXISTS $POSTGRES_DB;"
docker exec rsvp-prod-db-1 psql -U "$POSTGRES_USER" -d postgres -c "CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;"

# Restore from backup
echo "$(date '+%Y-%m-%d %H:%M:%S') - Restoring from backup..."
gunzip -c "$BACKUP_FILE" | docker exec -i rsvp-prod-db-1 psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"

if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Restore completed successfully!"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: Restore failed!"
    exit 1
fi

echo ""
echo "NOTE: You may need to restart the server container:"
echo "  cd $PROJECT_DIR && docker compose restart server"
