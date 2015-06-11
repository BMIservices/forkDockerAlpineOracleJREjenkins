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
#  docker run -d --name ${IMAGE} -P ${IMAGE}:${TAG} &>/dev/null
#  port=$(docker port ${IMAGE} | grep 8080 | cut -d":" -f2)
#  sleep $SLEEP
#  curl --retry 10 --retry-delay 5 --silent --output /dev/null --location --head --write-out "%{http_code}" http://${host}:${port}
#  echo " - Status passed."
#  docker stop ${IMAGE} &>/dev/null
#  docker rm ${IMAGE} &>/dev/null
done

echo "[CI] ${IMAGE} tests okay on all tags."
