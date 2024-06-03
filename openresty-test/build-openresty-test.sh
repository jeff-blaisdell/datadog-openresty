#!/bin/bash
set -ex

DOCKER_IMAGE=jblaisdell/openresty-test
echo "Building OpenResty Test..."

docker build \
--platform linux/amd64 \
-t ${DOCKER_IMAGE}:latest .
