# Fast Crypto Options Pricing - Development Dockerfile
# This image contains build tools but doesn't copy source code
# Source code should be mounted at runtime: -v $(pwd):/app

FROM ubuntu:22.04

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
    # Development utilities
    vim \
    gdb \
    valgrind \
    && rm -rf /var/lib/apt/lists/*

# Set GCC-10 as default compiler (C++20 support)
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100

# Install Bazel 6.x using Bazelisk (works on all architectures)
RUN curl -fsSL https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-$(dpkg --print-architecture) -o /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel && \
    bazel version

# Set working directory (source will be mounted here)
WORKDIR /app

# Set environment variables
ENV CC=/usr/bin/gcc-10
ENV CXX=/usr/bin/g++-10

# Label metadata
LABEL maintainer="27sanjeevd"
LABEL description="Fast Crypto Options Pricing - Development Environment"
LABEL version="1.0-dev"

# Default command - keep container running for interactive use
CMD ["/bin/bash"]
