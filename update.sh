#!/usr/local/bin/bash
# Add files for each version and show some information on each version.

set -e

# set colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

# Script directory
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$1" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( vers/*/ )
fi
versions=( "${versions[@]%/}" )
sortedVers=$(printf '%s\n' "${versions[@]}"|sort -V)

dlVersions=$(curl -sSL 'http://mirrors.jenkins-ci.org/war/' | sed -rn 's!.*?>([0-9]+\.[0-9]+[0-9]+[0-9]).*!\1!gp' | sort -V | uniq)
for version in "${sortedVers[@]}"; do
  if [ ! $(echo "$dlVersions" | grep "$version") ]; then
    echo >&2 "${red}WARNING: Cannot find download version for ${version}!${reset}"
    continue
  fi

  cp docker-entrypoint.sh ${version}/
  sed -e 's/%%VERSION%%/'"$version"'/' < Dockerfile.tpl > "$version/Dockerfile"
done
