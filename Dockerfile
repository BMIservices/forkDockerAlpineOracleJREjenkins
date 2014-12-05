# ################################################################
# NAME: Dockerfile
# DESC: Docker file to create Jenk container.
#
# LOG:
# yyyy/mm/dd [name] [version]: [notes]
# 2014/10/15 cgwong [v0.1.0]: Initial creation.
# 2014/12/04 cgwong [v0.2.0]: Removed unnecessary files. 
#                             Added environment variables.
#                             Updated Jenkins version to 1.588
# ################################################################

# Pull latest Java 7
FROM dockerfile/java:oracle-java7
MAINTAINER Stuart Wong <cgs.wong@gmail.com>

# Install necessary software prerequisites
RUN apt-get -y update && apt-get -y install \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Pull Jenkins
##ENV JENKINS_VERSION latest
ENV JENKINS_VERSION 1.588
ENV JENKINS_USER jenkins
ENV JENKINS_GROUP jenkins
ENV JENKINS_HOME /opt/jenkins
# define url prefix for running jenkins behind Apache (https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache)
ENV JENKINS_PREFIX /

# Create a user
RUN mkdir -p ${JENKINS_HOME} \
  && groupadd ${JENKINS_GROUP}
  && useradd -d ${JENKINS_HOME} -m -s /bin/bash -g ${JENKINS_GROUP} -c "Jenkins Service User" ${JENKINS_USER}

# Download Jenkins file
##RUN curl -L http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war
RUN curl -L http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war -o ${JENKINS_HOME}/jenkins.war \
  && chown -R ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_HOME} \
  && ln -s ${JENKINS_HOME} ${JENKINS_HOME}-${JENKINS_VERSION}

# Expose user configurable persistent storage area
VOLUME ["${JENKINS_HOME}"]

# Listen for connections on main web interface: 8080
EXPOSE 8080

# Listen for attached slave agents on port/interface: 50000
EXPOSE 50000

USER ${JENKINS_USER}

# Include any plugins
##RUN mkdir /tmp/WEB-INF/plugins
##RUN curl -L https://updates.jenkins-ci.org/latest/git.hpi -o /tmp/WEB-INF/plugins/git.hpi
##RUN curl -L https://updates.jenkins-ci.org/latest/git-client.hpi -o /tmp/WEB-INF/plugins/git-client.hpi
##RUN cd /tmp; zip --grow /usr/share/jenkins/jenkins.war WEB-INF/*

COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
