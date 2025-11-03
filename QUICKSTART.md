# Quick Docker Development Guide

## ✅ Setup Complete!

Your Docker development environment is now ready. Here's how to use it:

## 🚀 Quick Commands

### Start Interactive Development Session
```bash
# Option 1: Direct docker run
docker run -it --rm \
  --mount type=bind,src="$(pwd)",dst=/app \
  crypto-options-pricing:dev

# Option 2: Using docker-compose (recommended)
docker-compose -f docker-compose.dev.yml up -d
docker-compose -f docker-compose.dev.yml exec crypto-options-dev /bin/bash
```

### Build Your Project
```bash
# Inside the container
bazel build //:main

# Or run directly from host
docker run -it --rm \
  --mount type=bind,src="$(pwd)",dst=/app \
  crypto-options-pricing:dev \
  bazel build //:main
```

### Run Tests
```bash
# Inside the container
bazel test //...

# Or from host
docker run -it --rm \
  --mount type=bind,src="$(pwd)",dst=/app \
  crypto-options-pricing:dev \
  bazel test //...
```

### Run Your Application
```bash
# After building, run the main executable
./bazel-bin/main

# Or build and run in one command
bazel run //:main
```

## 📋 Step-by-Step Workflow

Once you're inside the container (`root@container:/app#`):

```bash
# 1. First time: Build everything
bazel build //...

# 2. Run all tests to verify setup
bazel test //...

# 3. Build and run the main application
bazel run //:main

# 4. Or just build main and execute directly
bazel build //:main
./bazel-bin/main
```

**Note**: The first build will take several minutes as Bazel downloads all dependencies (Boost, SimdJSON, BoringSSL, GoogleTest). Subsequent builds will be much faster thanks to caching.

## 🔧 Key Features

✅ **No Source Copying**: Your code is mounted, not copied
✅ **Live Updates**: Edit locally, build in container instantly  
✅ **ARM64 Support**: Works on Apple Silicon Macs
✅ **Bazel Caching**: Bazelisk handles version management
✅ **Clean Environment**: Consistent build environment every time

## 📝 Development Workflow

1. **Edit code** on your Mac with your favorite IDE
2. **Build/test** inside the container
3. **All build artifacts** stay in the container
4. **Your host** stays clean - no local Bazel installation needed

## 🧹 Cleanup

```bash
# Stop dev container (if using docker-compose)
docker-compose -f docker-compose.dev.yml down

# Remove the dev image
docker rmi crypto-options-pricing:dev

# Clean up all Docker resources
docker system prune -a
```

## 💡 Tips

- Build artifacts persist in the container's `/app/bazel-*` directories
- These are visible on your host (as symlinks) but stored in the container
- Bazel cache is mounted in docker-compose.dev.yml for faster rebuilds
- Use `bazel clean` inside container if you need a fresh build

## 🐛 Troubleshooting

**Container exits immediately?**
- Add `--entrypoint /bin/bash` to get a shell

**Permission issues?**
- The container runs as root but your files are mounted with your user's permissions

**Slow builds?**
- First build downloads dependencies (cached for subsequent builds)
- Use docker-compose for persistent Bazel cache
