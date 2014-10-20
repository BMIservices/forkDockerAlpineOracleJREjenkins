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
RUN apt-get -y update && apt-get -y install \
    curl \
    git \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Pull latest Jenkins
ENV JENKINS_VERSION latest

# Create a user
RUN mkdir /usr/share/jenkins/ \
    && useradd -d /home/jenkins -m -s /bin/bash -u 102 jenkins

# Download Jenkins file
RUN curl -L http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war

# Setup 
ENV JENKINS_HOME /var/jenkins_home
RUN usermod -m -d "$JENKINS_HOME" jenkins \
    && chown -R jenkins "$JENKINS_HOME"

# Create persistent container volume
VOLUME /var/jenkins_home

# define url prefix for running jenkins behind Apache (https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache)
ENV JENKINS_PREFIX /

# Listen for connections on main web interface: 8080
EXPOSE 8080

# Listen for attached slave agents on port/interface: 50000
EXPOSE 50000

USER jenkins

# Include any plugins
##RUN mkdir /tmp/WEB-INF/plugins
##RUN curl -L https://updates.jenkins-ci.org/latest/git.hpi -o /tmp/WEB-INF/plugins/git.hpi
##RUN curl -L https://updates.jenkins-ci.org/latest/git-client.hpi -o /tmp/WEB-INF/plugins/git-client.hpi
##RUN cd /tmp; zip --grow /usr/share/jenkins/jenkins.war WEB-INF/*

COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
