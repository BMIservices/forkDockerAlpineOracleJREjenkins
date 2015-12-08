#!/usr/bin/env bash
# Add files for each version.

set -e

# Set values
pkg=${0##*/}
pkg_root=$(dirname "${BASH_SOURCE}")

# Source common script
source "${pkg_root}/common.sh"

# Script directory
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( 1.* )
fi
versions=( "${versions[@]%/}" )
versions=( $(printf '%s\n' "${versions[@]}"|sort -V) )

dlVersions=$(curl -sSL 'http://mirrors.jenkins-ci.org/war/' | sed -rn 's!.*?>([0-9]+\.[0-9]+[0-9]+[0-9]).*!\1!gp' | sort -V | uniq)
for version in "${versions[@]}"; do
  echo "${yellow}Updating version: ${version}${reset}"
  cp docker-entrypoint.sh "${version}/"
  sed -e 's/%%VERSION%%/'"$version"'/' < Dockerfile.tpl > "$version/Dockerfile"
done
echo "${green}Complete${reset}"
