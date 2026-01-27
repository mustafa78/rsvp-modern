#!/bin/bash
# Production Database Backup Script
# Run this script daily via cron to backup the prod database
#
# Cron example (daily at 2 AM):
#   0 2 * * * /path/to/rsvp-modern/scripts/backup-prod-db.sh >> /var/log/rsvp-backup.log 2>&1

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="${PROJECT_DIR}/backups"
RETENTION_DAYS=30

# Load environment variables from .env file
if [ -f "${PROJECT_DIR}/.env" ]; then
    export $(grep -v '^#' "${PROJECT_DIR}/.env" | xargs)
fi

# Defaults
POSTGRES_DB="${POSTGRES_DB:-rsvp}"
POSTGRES_USER="${POSTGRES_USER:-rsvp}"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate backup filename with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/rsvp_prod_${TIMESTAMP}.sql.gz"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting backup..."

# Run pg_dump inside the prod database container and compress
docker exec rsvp-prod-db-1 pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup completed: $BACKUP_FILE ($BACKUP_SIZE)"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: Backup failed!"
    exit 1
fi

# Remove backups older than retention period
echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "rsvp_prod_*.sql.gz" -type f -mtime +$RETENTION_DAYS -delete

# List remaining backups
BACKUP_COUNT=$(find "$BACKUP_DIR" -name "rsvp_prod_*.sql.gz" -type f | wc -l)
echo "$(date '+%Y-%m-%d %H:%M:%S') - Total backups retained: $BACKUP_COUNT"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Done."
