#! /bin/bash
# #########################################
# DESC: Build images.
# #########################################

# Exit immediately upon failure and carry failures over pipes
set -eo pipefail

IMAGE=${1:-"jenkins"}

versions=( */ )
versions=( "${versions[@]%/}" )

for TAG in "${versions[@]}"; do
  echo "[CI] Building image: ${IMAGE}:${TAG}"
  docker build -t ${IMAGE}:${TAG} ${TAG}/
done

echo "[CI] All tags build okay."
