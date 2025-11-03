# Fast Crypto Options Pricing - Dockerfile
# Multi-stage build for optimized image size

# Stage 1: Build environment
FROM ubuntu:22.04 AS builder

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    # Core build tools
    build-essential \
    gcc-10 \
    g++-10 \
    cmake \
    git \
    wget \
    curl \
    unzip \
    pkg-config \
    # Bazel dependencies
    apt-transport-https \
    gnupg \
    ca-certificates \
    # SSL/TLS libraries for BoringSSL and WebSocket
    libssl-dev \
    # System utilities
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set GCC-10 as default compiler (C++20 support)
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100

# Install Bazel 6.x using Bazelisk (works on all architectures)
RUN curl -fsSL https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-$(dpkg --print-architecture) -o /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel && \
    bazel version

# Set working directory
WORKDIR /app

# Copy only dependency files first for better layer caching
COPY WORKSPACE MODULE.bazel BUILD .bazelrc* ./
COPY third_party/ ./third_party/

# Download and cache Bazel dependencies
RUN --mount=type=cache,target=/root/.cache/bazel \
    bazel fetch //...

# Copy source files (only what's needed for build)
COPY main.cpp ./
COPY ExchangeConnectivity/ ./ExchangeConnectivity/
COPY FeedProcessing/ ./FeedProcessing/
COPY IPCConnection/ ./IPCConnection/
COPY orderbook/ ./orderbook/
COPY pricing/ ./pricing/
COPY Types/ ./Types/

# Build the project with Bazel
# Using optimized compilation flags for production
# Mount Bazel cache for faster rebuilds
RUN --mount=type=cache,target=/root/.cache/bazel \
    bazel build --compilation_mode=opt \
    --copt=-O3 \
    --copt=-march=native \
    --copt=-DNDEBUG \
    //:main

# Build tests (optional, comment out to speed up build)
RUN --mount=type=cache,target=/root/.cache/bazel \
    bazel test --test_output=summary //...

# Copy the binary to a known location
RUN cp bazel-bin/main /app/crypto_options_main

# Stage 2: Runtime environment (slim image)
FROM ubuntu:22.04 AS runtime

# Install only runtime dependencies
RUN apt-get update && apt-get install -y \
    # SSL/TLS runtime libraries
    libssl3 \
    ca-certificates \
    # Utilities for debugging (optional, remove for minimal size)
    curl \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN useradd -m -u 1000 -s /bin/bash cryptotrader && \
    mkdir -p /tmp/sockets && \
    chown -R cryptotrader:cryptotrader /tmp/sockets

# Set working directory
WORKDIR /home/cryptotrader

# Copy binary from builder stage
COPY --from=builder --chown=cryptotrader:cryptotrader /app/crypto_options_main .

# Copy any configuration files if they exist
COPY --from=builder --chown=cryptotrader:cryptotrader /app/README.md ./README.md

# Switch to non-root user
USER cryptotrader

# Create socket directory for IPC
RUN mkdir -p /tmp/market_data /tmp/bbo_data /tmp/pricing_data

# Set environment variables
ENV MARKET_DATA_SOCKET=/tmp/market_data.sock
ENV BBO_OUTPUT_SOCKET=/tmp/bbo_output.sock
ENV PRICING_INPUT_SOCKET=/tmp/pricing_input.sock

# Health check (adjust port if needed)
# HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
#   CMD curl -f http://localhost:8080/health || exit 1

# Expose ports if the application has HTTP/WebSocket server endpoints
# EXPOSE 8080

# Label metadata
LABEL maintainer="27sanjeevd"
LABEL description="Fast Crypto Options Pricing - High-performance real-time cryptocurrency options pricing system"
LABEL version="1.0"

# Default command
CMD ["./crypto_options_main"]

# Alternative: Run in interactive mode for debugging
# CMD ["/bin/bash"]
