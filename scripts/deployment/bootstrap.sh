#!/bin/bash

set -x

./scripts/deployment/dkc.build run --rm build
./scripts/deployment/dkc.build build dist
docker save hiogawa/rails-docker-production -o ./scripts/deployment/image.tar
./scripts/development/dkc run --rm rails bundle exec cap production docker_deploy:bootstrap
