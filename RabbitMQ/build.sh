#!/bin/bash
set -x

export GHCR_PAT=""

echo "$GHCR_PAT" | docker login ghcr.io -u gmbenz --password-stdin

docker build -f Dockerfile.producer -t ghcr.io/gmbenz/producer:latest .
docker push ghcr.io/gmbenz/producer:latest

docker build -f Dockerfile.consumer -t ghcr.io/gmbenz/consumer:latest .
docker push ghcr.io/gmbenz/consumer:latest
