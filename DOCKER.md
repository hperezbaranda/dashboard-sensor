# Docker Setup for Dashboard Sensor

This project is fully containerized using Docker and Docker Compose.

## Quick Start

### Development Mode (with hot reload)
```bash
# Build and run in development mode
make dev
# or
docker-compose up --build
```

### Production Mode (with nginx reverse proxy)
```bash
# Build and run in production mode
make prod
# or
docker-compose --profile production up --build -d
```

## Available Commands

| Command | Description |
|---------|-------------|
| `make build` | Build the Docker image |
| `make dev` | Run in development mode with hot reload |
| `make prod` | Run in production mode with nginx |
| `make stop` | Stop all running containers |
| `make clean` | Remove containers and images |
| `make logs` | Show application logs |
| `make shell` | Open shell in running container |
| `make test` | Test application endpoints |

## Docker Files

- `Dockerfile` - Production-ready container
- `Dockerfile.dev` - Development container with hot reload
- `docker-compose.yml` - Multi-service configuration
- `docker-compose.override.yml` - Development overrides
- `nginx.conf` - Nginx reverse proxy configuration
- `.dockerignore` - Files to exclude from Docker build

## Ports

- **8000** - Direct application access (development)
- **80** - Nginx reverse proxy (production)

## Environment Variables

Copy `.env.example` to `.env` and modify as needed:

```bash
cp .env.example .env
```

## Health Checks

The application includes health checks:
- HTTP endpoint: `http://localhost:8001/`
- Docker health check runs every 30 seconds

## Volumes

In development mode, source code is mounted as a volume for hot reload:
```yaml
volumes:
  - .:/app
```

## Production Deployment

For production deployment:

1. Use the production Docker Compose profile:
   ```bash
   docker-compose --profile production up -d
   ```

2. Or build and run manually:
   ```bash
   docker build -t dashboard-sensor .
   docker run -d -p 8000:8000 dashboard-sensor
   ```

## Troubleshooting

### View logs
```bash
docker-compose logs -f dashboard-sensor
```

### Access container shell
```bash
docker-compose exec dashboard-sensor /bin/bash
```

### Rebuild completely
```bash
docker-compose down --rmi all
docker-compose up --build
```

### Check application health
```bash
curl http://localhost:8001/
curl http://localhost:8001/current
```