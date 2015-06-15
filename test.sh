#! /bin/bash
# #########################################
# DESC: Run testing.
# #########################################

SLEEP=30
# Exit immediately upon failure and carry failures over pipes
set -eo pipefail

IMAGE="jenkins" ; export IMAGE
host=$(echo $DOCKER_HOST|cut -d":" -f2|sed -e 's/\/\///')

versions=( 1.*/ )
versions=( "${versions[@]%/}" )

for TAG in "${versions[@]}"; do
  echo "[CI] -----------------------------------------------"
  echo "[CI] Running tests for: ${IMAGE}:${TAG}"
  export TAG
  bats tests
done

echo "[CI] ${IMAGE} tests okay on all tags."
