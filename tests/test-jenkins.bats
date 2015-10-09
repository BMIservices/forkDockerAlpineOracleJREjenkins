#! /usr/bin/env bats

setup() {
  # Setup environment
  host=$(echo $DOCKER_HOST|cut -d":" -f2|sed -e 's/\/\///')

  # Launch container
  docker run -d --name ${DOCKER_IMAGE} -P ${DOCKER_IMAGE}:${VERSION}
  port=$(docker port ${DOCKER_IMAGE} | grep 8080 | cut -d":" -f2)
  url="http://${host}:${port}"
}

teardown () {
  # Cleanup
  docker stop ${DOCKER_IMAGE} &>/dev/null
  docker rm -f ${DOCKER_IMAGE} &>/dev/null
}

@test "Check Jenkins status" {
  sleep 15
  run curl --retry 10 --retry-delay 5 --silent --output /dev/null --location --head --write-out "%{http_code}" $url
  [[ "$output" =~ "200" ]]
}
