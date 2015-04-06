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
# 2015/04/06 cgwong v1.0.0]: Update to 1.608, use own OraJDK8 base image, optimize RUN commands.
# ################################################################

# Pull latest Java 7
FROM cgswong/java:orajdk8
MAINTAINER Stuart Wong <cgs.wong@gmail.com>

# Setup environment
ENV JENKINS_VERSION 1.608
ENV JENKINS_USER jenkins
ENV JENKINS_GROUP jenkins
ENV JENKINS_HOME /opt/jenkins
# define url prefix for running jenkins behind Apache (https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache)
ENV JENKINS_PREFIX /

# Install necessary software prerequisites and setup user
RUN apt-get -y update && apt-get -y install \
    curl \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p ${JENKINS_HOME} \
  && groupadd ${JENKINS_GROUP} \
  && useradd -d ${JENKINS_HOME} -m -s /bin/bash -g ${JENKINS_GROUP} -c "Jenkins Service User" ${JENKINS_USER} \
  && curl -L http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war -o ${JENKINS_HOME}/jenkins.war \
  && chown -R ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_HOME}

COPY init.groovy /tmp/WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy
RUN curl -L http://nectar-downloads.cloudbees.com/jenkins-enterprise/$JENKINS_VERSION/war/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war \
  && cd /tmp && zip -g /usr/share/jenkins/jenkins.war WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy && rm -rf /tmp/WEB-INF

# Listen for main web interface (8080/tcp) and attached slave agents 50000/tcp
EXPOSE 8080 50000

USER ${JENKINS_USER}

COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]