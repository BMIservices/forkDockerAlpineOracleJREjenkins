# ################################################################
# NAME: Dockerfile
# DESC: Docker file to create Jenk container.
#
# LOG:
# yyyy/mm/dd [name] [version]: [notes]
# 2014/10/15 cgwong [v0.1.0]: Initial creation.
# ################################################################

# Pull latest Java 7
FROM dockerfile/java:oracle_java7
MAINTAINER Stuart Wong <cgs.wong@gmail.com>

# Install necessary software prerequisites
USER root
RUN apt-get -y update && apt-get -y install wget git curl zip && rm -rf /var/lib/apt/lists/*

# Pull latest Jenkins
ENV JENKINS_VERSION latest

# Create a user
RUN mkdir /usr/share/jenkins/
RUN useradd -d /home/jenkins -m -s /bin/bash -u 102 jenkins

RUN curl -L http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war

ENV JENKINS_HOME /var/jenkins_home
RUN usermod -m -d "$JENKINS_HOME" jenkins && chown -R jenkins "$JENKINS_HOME"
VOLUME /var/jenkins_home

# define url prefix for running jenkins behind Apache (https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache)
ENV JENKINS_PREFIX /

# Expose main web interface:
EXPOSE 8080

# Expose for attached slave agents:
EXPOSE 50000

USER jenkins

# Include any plugins
##RUN mkdir /tmp/WEB-INF/plugins
##RUN curl -L https://updates.jenkins-ci.org/latest/git.hpi -o /tmp/WEB-INF/plugins/git.hpi
##RUN curl -L https://updates.jenkins-ci.org/latest/git-client.hpi -o /tmp/WEB-INF/plugins/git-client.hpi
##RUN cd /tmp; zip --grow /usr/share/jenkins/jenkins.war WEB-INF/*

COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
