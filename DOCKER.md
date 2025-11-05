# Docker Deployment Guide

## 🐳 Quick Start

### Build the Development Image

```bash
# Build the Docker image
docker build -t crypto-options-pricing:dev .
```

### Run with Mounted Source Code

Mount the entire repository for live development:

```bash
# Run with mounted source code
docker run -it --rm \
  --mount type=bind,src="$(pwd)",dst=/app \
  crypto-options-pricing:dev

# Or build inside the container
docker run -it --rm \
  --mount type=bind,src="$(pwd)",dst=/app \
  crypto-options-pricing:dev \
  bazel build //:main
```

### Using Docker Compose (Recommended)

```bash
# Build and start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and restart
docker-compose up -d --build
```

### Development with Docker Compose (Recommended)

The `docker-compose.yml` is configured for development with live source code mounting:

```bash
# Start dev container
docker-compose up -d

# Access the container
docker-compose exec crypto-options-dev /bin/bash

# Build inside container
docker-compose exec crypto-options-dev bazel build //:main

# Run tests
docker-compose exec crypto-options-dev bazel test //...
```

## 📋 Configuration

### Environment Variables

Configure the application by setting environment variables:

```bash
docker run -d \
  -e MARKET_DATA_SOCKET=/tmp/market_data.sock \
  -e BBO_OUTPUT_SOCKET=/tmp/bbo_output.sock \
  -e PRICING_INPUT_SOCKET=/tmp/pricing_input.sock \
  crypto-options-pricing:latest
```

### Volume Mounts

Mount volumes for persistent data and logs:

```bash
docker run -d \
  -v $(pwd)/logs:/home/cryptotrader/logs \
  -v crypto_sockets:/tmp \
  crypto-options-pricing:latest
```

## 🔧 Advanced Usage

### Development Build

The Dockerfile is already configured for development:

```bash
# Build the dev image
docker build -t crypto-options-pricing:dev .

# Run with interactive shell
docker run -it --rm crypto-options-pricing:dev /bin/bash
```

### Custom Build Arguments

Modify build configuration:

```dockerfile
# In Dockerfile, add ARG directives
ARG BAZEL_VERSION=6.5.0
ARG OPTIMIZATION_LEVEL=3
```

```bash
# Build with custom arguments
docker build \
  --build-arg BAZEL_VERSION=6.5.0 \
  --build-arg OPTIMIZATION_LEVEL=3 \
  -t crypto-options-pricing:dev .
```

### Multi-Platform Builds

Build for different architectures:

```bash
# Enable buildx
docker buildx create --use

# Build for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t crypto-options-pricing:dev \
  --push .
```

## 🐛 Debugging

### View Logs

```bash
# Docker
docker logs -f crypto_options

# Docker Compose
docker-compose logs -f crypto-options-pricing
```

### Execute Commands in Container

```bash
# Open shell in running container
docker exec -it crypto_options /bin/bash

# Check process status
docker exec crypto_options ps aux

# View socket files
docker exec crypto_options ls -la /tmp/*.sock
```

### Inspect Container

```bash
# View container details
docker inspect crypto_options

# Check resource usage
docker stats crypto_options
```

## 🚀 Production Deployment

### Resource Limits

Set appropriate resource constraints:

```bash
docker run -d \
  --name crypto_options \
  --cpus="4.0" \
  --memory="8g" \
  --memory-swap="8g" \
  crypto-options-pricing:latest
```

### Security Hardening

```bash
docker run -d \
  --name crypto_options \
  --read-only \
  --tmpfs /tmp \
  --security-opt=no-new-privileges \
  --cap-drop=ALL \
  --user 1000:1000 \
  crypto-options-pricing:latest
```

### Networking

```bash
# Create custom network
docker network create crypto_net

# Run with custom network
docker run -d \
  --name crypto_options \
  --network crypto_net \
  crypto-options-pricing:latest
```

### Health Checks

Monitor container health:

```bash
# Check health status
docker inspect --format='{{.State.Health.Status}}' crypto_options

# View health check logs
docker inspect --format='{{json .State.Health}}' crypto_options | jq
```

## 📊 Monitoring

### Resource Monitoring

```bash
# Real-time stats
docker stats crypto_options

# Export metrics
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" --no-stream
```

### Log Management

```bash
# View logs with timestamps
docker logs -t crypto_options

# Follow logs with tail
docker logs -f --tail 100 crypto_options

# Export logs
docker logs crypto_options > app.log
```

## 🔄 Updates and Maintenance

### Update Container

```bash
# Pull latest changes
git pull

# Rebuild and restart
docker-compose up -d --build

# Or rebuild with Docker directly
docker build -t crypto-options-pricing:dev .
docker-compose restart
```

### Backup and Restore

```bash
# Backup volumes
docker run --rm \
  -v crypto_sockets:/data \
  -v $(pwd)/backup:/backup \
  ubuntu tar czf /backup/sockets-backup.tar.gz /data

# Restore volumes
docker run --rm \
  -v crypto_sockets:/data \
  -v $(pwd)/backup:/backup \
  ubuntu tar xzf /backup/sockets-backup.tar.gz -C /
```

### Clean Up

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Complete cleanup
docker system prune -a --volumes
```

## 🔐 Registry Management

### Push to Registry

```bash
# Tag image
docker tag crypto-options-pricing:latest your-registry.com/crypto-options-pricing:latest

# Login to registry
docker login your-registry.com

# Push image
docker push your-registry.com/crypto-options-pricing:latest
```

### Pull from Registry

```bash
# Pull specific version
docker pull your-registry.com/crypto-options-pricing:v1.0.0

# Run pulled image
docker run -d your-registry.com/crypto-options-pricing:v1.0.0
```

## 🏗️ CI/CD Integration

### GitHub Actions Example

```yaml
name: Build and Push Docker Image

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Build Docker image
        run: docker build -t crypto-options-pricing:${{ github.sha }} .
      
      - name: Run tests
        run: docker run crypto-options-pricing:${{ github.sha }} bazel test //...
```

## 📝 Troubleshooting

### Common Issues

**Issue: Build fails with Bazel errors**
```bash
# Clean Bazel cache and rebuild
docker build --no-cache -t crypto-options-pricing:dev .
```

**Issue: Container exits immediately**
```bash
# Check logs for errors
docker-compose logs

# Run in interactive mode
docker run -it --rm crypto-options-pricing:dev /bin/bash
```

**Issue: Out of memory**
```bash
# Increase memory limit in docker-compose.yml
# Edit the limits section under deploy.resources
```

**Issue: Network connectivity problems**
```bash
# Check DNS resolution
docker-compose exec crypto-options-dev nslookup stream.crypto.com

# Test network connectivity
docker exec crypto_options curl -I https://stream.crypto.com
```

## 📚 Additional Resources

- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Security](https://docs.docker.com/engine/security/)
- [Project README](./README.md)
