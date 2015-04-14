#! /bin/bash

set -eo pipeline

JENKINS_HOME=/opt/jenkins
PLUGINS_ENDPOINT=http://updates.jenkins-ci.org/latest/
JENKINS_PLUGINS=/opt/jenkins/plugins

# Install plugins
for plugins in credentials ssh-credentials ssh-agent ssh-slaves git-client git github github-api github-oauth ghprb scm-api postbuild-task; do
  curl --insecure -Ls $PLUGINS_ENDPOINT/${plugins}.hpi -o $JENKINS_PLUGINS/${plugins}.hpi
done

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
  exec java $JAVA_OPTS -jar ${JENKINS_HOME}/jenkins.war $JENKINS_OPTS --prefix=$JENKINS_PREFIX "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
