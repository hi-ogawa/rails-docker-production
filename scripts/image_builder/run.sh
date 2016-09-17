#!/bin/bash

set -x

# Prepare source
mkdir -p source tar_archives
git clone --depth 1 --single-branch --branch ${BRANCH:-master} \
  git@github.com:hi-ogawa/rails-docker-production.git \
  source

# Set image tag
DATE=$(date +'%Y-%m-%d-%H-%M-%S')
COMMIT_HASH=$(cd source && git rev-parse HEAD)
export IMAGE_TAG=$DATE--$COMMIT_HASH

# Build docker image
docker-compose -p rdp-image-builder run --rm build
docker-compose -p rdp-image-builder build dist
docker push hiogawa/rails-docker-production:$IMAGE_TAG

# Clean up
sudo rm -rf source tar_archives
