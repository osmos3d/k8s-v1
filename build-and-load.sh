#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="my-nginx"
IMAGE_TAG="${1:-v1}"
WORKER="root@node01"

IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"
TAR_FILE="${IMAGE_NAME}-${IMAGE_TAG}.tar"

echo "==> Building ${IMAGE}"
docker build -t "${IMAGE}" .

echo "==> Saving ${IMAGE}"
docker save "${IMAGE}" -o "${TAR_FILE}"


echo "==> Importing image into containerd"
ctr -n k8s.io images import ~/${TAR_FILE} && rm ~/${TAR_FILE}

echo "==> Removing local tar"
rm "${TAR_FILE}"

echo "==> Done: ${IMAGE}"