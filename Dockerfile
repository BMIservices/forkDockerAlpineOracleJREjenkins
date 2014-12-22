<<<<<<< HEAD
<<<<<<< HEAD
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
=======
FROM java:openjdk-7u65-jdk
>>>>>>> e19357018e795585f1e978710c1dc18b24424439

# Pull latest Java 7
FROM dockerfile/java:oracle-java7
MAINTAINER Stuart Wong <cgs.wong@gmail.com>

<<<<<<< HEAD
# Install necessary software prerequisites
RUN apt-get -y update && apt-get -y install \
    curl \
    && rm -rf /var/lib/apt/lists/*
=======
ENV JENKINS_VERSION 1.565.3.1
RUN mkdir /usr/share/jenkins/
RUN useradd -d /home/jenkins -m -s /bin/bash jenkins

COPY init.groovy /tmp/WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy
RUN curl -L http://nectar-downloads.cloudbees.com/jenkins-enterprise/$JENKINS_VERSION/war/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war \
  && cd /tmp && zip -g /usr/share/jenkins/jenkins.war WEB-INF/init.groovy.d/tcp-slave-angent-port.groovy && rm -rf /tmp/WEB-INF

ENV JENKINS_HOME /var/jenkins_home
RUN usermod -m -d "$JENKINS_HOME" jenkins && chown -R jenkins "$JENKINS_HOME"
VOLUME /var/jenkins_home
>>>>>>> e19357018e795585f1e978710c1dc18b24424439

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
  && groupadd ${JENKINS_GROUP} \
  && useradd -d ${JENKINS_HOME} -m -s /bin/bash -g ${JENKINS_GROUP} -c "Jenkins Service User" ${JENKINS_USER}

# Download Jenkins file
##RUN curl -L http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war
RUN curl -L http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war -o ${JENKINS_HOME}/jenkins.war \
  && chown -R ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_HOME}

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
=======
FROM ubuntu:13.10
MAINTAINER Zaiste <oh [at] zaiste.net>

RUN apt-get update \
  && apt-get -q -y install wget git openjdk-7-jre-headless \
  && echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list \
  && wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y jenkins \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

VOLUME /var/lib/jenkins
ENV JENKINS_HOME /var/lib/jenkins

EXPOSE 8080

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

<<<<<<< HEAD
CMD /usr/local/bin/run
>>>>>>> 3b38b0ff5b412d055425611ad8be47a97386daa6
=======
COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
>>>>>>> e19357018e795585f1e978710c1dc18b24424439
