#! /bin/bash

set -eo pipefail

JENKINS_HOME=/opt/jenkins
PLUGINS_ENDPOINT=${PLUGINS_ENDPOINT:-"http://updates.jenkins-ci.org/latest/"}
JENKINS_PLUGINS=/var/lib/jenkins/plugins
JENKINS_USER=jenkins
JENKINS_GROUP=jenkins

# Install plugins
mkdir -p $JENKINS_PLUGINS
for plugins in credentials ssh-credentials ssh-agent ssh-slaves git-client git github github-api github-oauth ghprb scm-api postbuild-task greenballs; do
  curl --silent --location --insecure $PLUGINS_ENDPOINT/${plugins}.hpi --output $JENKINS_PLUGINS/${plugins}.hpi
done

chown -R $JENKINS_USER:$JENKINS_GROUP $JENKINS_PLUGINS

# if `docker run` first argument start with `--` the user is passing Jenkins launcher arguments
if [[ $# -ge 1 ]] || [[ "$1" == "--"* ]]; then
  java -jar ${JENKINS_HOME}/jenkins.war "$@"
else
  exec "$@"
fi
