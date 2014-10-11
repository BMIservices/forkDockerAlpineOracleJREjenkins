# Pull latest Java 7
FROM dockerfile/java:oracle_java7
MAINTAINER Stuart Wong <cgs.wong@gmail.com>

# Install necessary software prerequisites
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

# for main web interface:
EXPOSE 8080

USER jenkins

COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
