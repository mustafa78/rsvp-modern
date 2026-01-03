# RSVP Modern - Deployment Guide

This guide provides step-by-step instructions for deploying the RSVP application to a cloud server and migrating data from a local environment.

---

## Prerequisites

- A Debian-based cloud server (tested on IONOS, but works with AWS, DigitalOcean, Linode, etc.)
- SSH access to the server
- Git repository access
- Local development environment running (for data migration)

---

## Part 1: Server Setup

### Step 1: Install Docker and Docker Compose

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (so you don't need sudo)
sudo usermod -aG docker $USER

# Log out and back in, or run:
newgrp docker

# Verify installation
docker --version
docker compose version
```

### Step 2: Clone the Repository

```bash
# Navigate to home directory
cd /home/$USER

# Clone the repository
git clone https://github.com/mustafa78/rsvp-modern.git
cd rsvp-modern

# Ensure you have the latest code
git pull origin main
```

### Step 3: Create Environment File

```bash
# Copy the dev environment file
cp .env.dev .env.dev.server

# Edit if needed (defaults should work)
nano .env.dev.server
```

Default `.env.dev` contents:
```
POSTGRES_USER=rsvp
POSTGRES_PASSWORD=rsvp
POSTGRES_DB=rsvp
```

### Step 4: Start the Application

```bash
# Start the dev environment
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d --build

# Check if containers are running
docker compose -f docker-compose.dev.yml ps

# View logs if needed
docker compose -f docker-compose.dev.yml logs -f
```

### Step 5: Configure Firewall

#### Using UFW (Recommended)
```bash
sudo apt install -y ufw
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 5173/tcp  # Frontend (dev)
sudo ufw allow 8080/tcp  # Backend API
sudo ufw enable
sudo ufw status
```

#### Using iptables
```bash
sudo iptables -A INPUT -p tcp --dport 5173 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
```

---

## Part 2: Data Migration

### Step 1: Backup Local Database (on your local machine)

```bash
# Navigate to project directory
cd /path/to/rsvp-modern

# Ensure local containers are running
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d

# Create a full database backup
docker compose -f docker-compose.dev.yml exec db pg_dump -U rsvp -d rsvp > db_backup_full.sql

# Verify the backup
ls -la db_backup_full.sql
head -50 db_backup_full.sql
```

### Step 2: Transfer Backup to Server

```bash
# Replace YOUR_SERVER_IP with your server's IP address
# Replace your_user with your SSH username

# Using SCP
scp db_backup_full.sql your_user@YOUR_SERVER_IP:/home/your_user/rsvp-modern/

# Or using rsync (more reliable for large files)
rsync -avz --progress db_backup_full.sql your_user@YOUR_SERVER_IP:/home/your_user/rsvp-modern/
```

### Step 3: Restore Database on Server

```bash
# SSH into your server
ssh your_user@YOUR_SERVER_IP

# Navigate to project directory
cd ~/rsvp-modern

# Ensure containers are running
docker compose -f docker-compose.dev.yml ps

# Wait for database to be ready
docker compose -f docker-compose.dev.yml logs db | tail -20
# Look for: "database system is ready to accept connections"

# Drop existing data and restore from backup
docker compose -f docker-compose.dev.yml exec -T db psql -U rsvp -d rsvp -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
docker compose -f docker-compose.dev.yml exec -T db psql -U rsvp -d rsvp < db_backup_full.sql

# Alternative method if above fails
cat db_backup_full.sql | docker compose -f docker-compose.dev.yml exec -T db psql -U rsvp -d rsvp
```

### Step 4: Verify Data Restoration

```bash
# Connect to database
docker compose -f docker-compose.dev.yml exec db psql -U rsvp -d rsvp

# Run verification queries
\dt                           -- List all tables
SELECT COUNT(*) FROM persons; -- Check user count
SELECT COUNT(*) FROM events;  -- Check event count
SELECT COUNT(*) FROM dishes;  -- Check dish count
\q                            -- Exit psql
```

### Step 5: Restart Services

```bash
# Restart all containers
docker compose -f docker-compose.dev.yml down
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d

# Check logs for errors
docker compose -f docker-compose.dev.yml logs -f server
```

---

## Part 3: Accessing the Application

Once everything is running:

| Service | URL |
|---------|-----|
| Frontend | `http://YOUR_SERVER_IP:5173` |
| Backend API | `http://YOUR_SERVER_IP:8080/api` |
| Database | `localhost:5433` (internal only) |

Default admin credentials:
- **ITS**: 30702039
- **Password**: moulatus

---

## Part 4: Common Operations

### Starting and Stopping

```bash
# Start containers
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d

# Stop containers
docker compose -f docker-compose.dev.yml down

# Stop and remove volumes (WARNING: deletes all data)
docker compose -f docker-compose.dev.yml down -v
```

### Viewing Logs

```bash
# All services
docker compose -f docker-compose.dev.yml logs -f

# Specific service
docker compose -f docker-compose.dev.yml logs -f server
docker compose -f docker-compose.dev.yml logs -f web
docker compose -f docker-compose.dev.yml logs -f db
```

### Updating the Application

```bash
cd ~/rsvp-modern

# Pull latest code
git pull origin main

# Rebuild and restart
docker compose -f docker-compose.dev.yml down
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d --build
```

### Database Operations

```bash
# Access database shell
docker compose -f docker-compose.dev.yml exec db psql -U rsvp -d rsvp

# Create a backup
docker compose -f docker-compose.dev.yml exec db pg_dump -U rsvp -d rsvp > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore a backup
docker compose -f docker-compose.dev.yml exec -T db psql -U rsvp -d rsvp < backup_file.sql
```

### Restarting Services

```bash
# Restart all
docker compose -f docker-compose.dev.yml restart

# Restart specific service
docker compose -f docker-compose.dev.yml restart server
docker compose -f docker-compose.dev.yml restart web
docker compose -f docker-compose.dev.yml restart db
```

### Checking Container Status

```bash
# List running containers
docker compose -f docker-compose.dev.yml ps

# Check resource usage
docker stats
```

---

## Part 5: Troubleshooting

### Container Won't Start

```bash
# Check logs for errors
docker compose -f docker-compose.dev.yml logs --tail=100

# Rebuild from scratch
docker compose -f docker-compose.dev.yml down
docker system prune -f
docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d --build
```

### Database Connection Issues

```bash
# Check if database is running
docker compose -f docker-compose.dev.yml ps db

# Check database logs
docker compose -f docker-compose.dev.yml logs db

# Test connection
docker compose -f docker-compose.dev.yml exec db pg_isready -U rsvp
```

### Port Already in Use

```bash
# Find what's using the port
sudo lsof -i :5173
sudo lsof -i :8080

# Kill the process if needed
sudo kill -9 <PID>
```

### Out of Disk Space

```bash
# Check disk usage
df -h

# Clean up Docker resources
docker system prune -a
docker volume prune
```

### Server Logs Show Permission Errors

```bash
# Fix permissions on project directory
sudo chown -R $USER:$USER ~/rsvp-modern
```

---

## Part 6: Production Considerations

For production deployment, consider the following:

### 1. Use Production Docker Compose

```bash
# Use production config instead of dev
docker compose --env-file ./.env -f docker-compose.yml up -d --build
```

### 2. Set Up HTTPS with Let's Encrypt

```bash
# Install certbot
sudo apt install -y certbot

# Get certificate (replace with your domain)
sudo certbot certonly --standalone -d yourdomain.com

# Configure nginx to use HTTPS
# Update nginx.conf in the project
```

### 3. Secure Environment Variables

```bash
# Create production .env file with strong passwords
nano .env

# Contents:
POSTGRES_USER=rsvp
POSTGRES_PASSWORD=<STRONG_PASSWORD_HERE>
POSTGRES_DB=rsvp
```

### 4. Set Up Automatic Backups

```bash
# Create backup script
cat > ~/backup_rsvp.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
cd ~/rsvp-modern
docker compose -f docker-compose.dev.yml exec -T db pg_dump -U rsvp -d rsvp > $BACKUP_DIR/rsvp_$DATE.sql
# Keep only last 7 days
find $BACKUP_DIR -name "rsvp_*.sql" -mtime +7 -delete
EOF

chmod +x ~/backup_rsvp.sh

# Add to crontab (daily at 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * ~/backup_rsvp.sh") | crontab -
```

### 5. Set Up Domain Name

1. Purchase a domain or use a subdomain
2. Point DNS A record to your server IP
3. Configure nginx to use the domain
4. Set up SSL certificate

### 6. Enable Auto-Start on Reboot

```bash
# Create systemd service
sudo nano /etc/systemd/system/rsvp.service

# Contents:
[Unit]
Description=RSVP Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/your_user/rsvp-modern
ExecStart=/usr/bin/docker compose --env-file ./.env.dev -f docker-compose.dev.yml up -d
ExecStop=/usr/bin/docker compose -f docker-compose.dev.yml down
User=your_user

[Install]
WantedBy=multi-user.target

# Enable the service
sudo systemctl enable rsvp.service
sudo systemctl start rsvp.service
```

---

## Quick Reference

### URLs (Development)
| Service | Port | URL |
|---------|------|-----|
| Frontend | 5173 | http://SERVER_IP:5173 |
| Backend | 8080 | http://SERVER_IP:8080/api |
| Database | 5433 | localhost:5433 (internal) |

### Default Credentials
| Field | Value |
|-------|-------|
| ITS | 30702039 |
| Password | moulatus |
| Role | ADMIN |

### Docker Compose Files
| File | Purpose |
|------|---------|
| `docker-compose.dev.yml` | Development with hot reload |
| `docker-compose.yml` | Production with nginx |

### Key Directories
| Path | Purpose |
|------|---------|
| `server/` | Spring Boot backend |
| `web/` | React frontend |
| `server/src/main/resources/db/migration/` | Flyway migrations |
| `server/src/main/resources/db/seed/` | Seed data |

---

## Support

For issues or questions:
- Check the logs first: `docker compose -f docker-compose.dev.yml logs -f`
- Review this guide's troubleshooting section
- Check the session notes in `rsvp-modern-session.md`

---

*Last updated: January 2, 2026*
