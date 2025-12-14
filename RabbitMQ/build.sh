#!/bin/bash
set -x

GHCR_PAT=""

echo "$GHCR_PAT" | docker login ghcr.io -u gmbenz --password-stdin

docker build -t yourrepo/producer .
docker push yourrepo/producer

docker build -t yourrepo/consumer .
docker push yourrepo/consumer
