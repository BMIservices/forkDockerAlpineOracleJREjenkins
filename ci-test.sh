#! /bin/bash
# Run testing.

# Set values
pkg=${0##*/}
pkg_path=$(cd $(dirname $0); pwd -P)

# set colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

DOCKER_IMAGE=${DOCKER_IMAGE:-"jenkins"} ; export DOCKER_IMAGE

versions=( "$VERSIONS" )
if [ ${#versions[@]} -eq 0 ]; then
  versions=( 1.* )
fi
versions=( "${versions[@]%/}" )
versions=( $(printf '%s\n' "${versions[@]}"|sort -V) )

for VERSION in "${versions[@]}"; do
  echo "${green}[CI] -----------------------------------------------"
  echo "${green}[CI] Building Docker image: ${DOCKER_IMAGE}:${VERSION}${reset}"
  docker build -t ${DOCKER_IMAGE}:${VERSION} ${VERSION}
  if [ $? -eq 0 ]; then
    echo "${green}[CI] Build successful for: ${DOCKER_IMAGE}:${VERSION}${reset}"
  else
    echo "${red}[CI] Build failed for: ${DOCKER_IMAGE}:${VERSION}${reset}"
  fi
done

echo "${yellow}[CI] ${DOCKER_IMAGE} tests completed, check logs above.${reset}"
