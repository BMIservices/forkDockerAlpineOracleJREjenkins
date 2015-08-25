#! /bin/bash
# Run testing.

SLEEP=30

# set colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

DOCKER_IMAGE=${1:-"jenkins"} ; export DOCKER_IMAGE

versions=( 1.*/ )
versions=( "${versions[@]%/}" )

for TAG in "${versions[@]}"; do
  echo "${green}[CI] -----------------------------------------------"
  echo "${green}[CI] Running tests for: ${DOCKER_IMAGE}:${TAG} ${reset}"
  export TAG
  bats tests
done

echo "${green}[CI] ${IMAGE} tests okay on all tags.${reset}"