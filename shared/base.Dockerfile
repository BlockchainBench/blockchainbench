# Base Dockerfile for BlockchainBench tasks
# Provides: Python 3.12, foundry (anvil/cast/forge), common dependencies

FROM ghcr.io/foundry-rs/foundry:latest

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    jq \
    bash

# Create and activate a virtual environment (avoids PEP 668 issues)
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies
RUN pip install --no-cache-dir \
    web3>=6.0.0 \
    pytest>=7.0.0 \
    eth-account>=0.10.0

# Copy shared libraries and scripts into the image
COPY libs/ /blockchainbench/libs/
COPY shared/ /blockchainbench/shared/

# Make shell scripts executable
RUN chmod +x /blockchainbench/shared/*.sh

# Set PYTHONPATH so libs are importable
ENV PYTHONPATH="/blockchainbench:${PYTHONPATH:-}"

WORKDIR /task

ENTRYPOINT ["/bin/bash"]
