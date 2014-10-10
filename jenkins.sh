#! /bin/bash
# #################################################################
# NAME: jenkins.sh
# DESC: Jenkins startup file.
#
# LOG:
# yyyy/mm/dd [user] [version]: [notes]
# 2014/10/08 cgwong v0.1.0: Initial creation from https://github.com/cloudbees/jenkins-ci.org-docker/blob/master/jenkins.sh
# #################################################################

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
   exec java $JAVA_OPTS -jar /usr/share/jenkins/jenkins.war $JENKINS_OPTS --prefix=$JENKINS_PREFIX "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
