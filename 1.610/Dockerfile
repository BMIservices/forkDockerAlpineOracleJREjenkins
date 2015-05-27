# ################################################################
# DESC: Docker file to create Jenkins container.
# ################################################################

FROM gliderlabs/alpine:3.1
MAINTAINER Stuart Wong <cgs.wong@gmail.com>

# Setup environment
ENV JENKINS_VERSION 1.610
ENV JENKINS_USER jenkins
ENV JENKINS_GROUP jenkins
ENV JENKINS_HOME /opt/jenkins
ENV JENKINS_VOL /var/lib/jenkins

ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 45
ENV JAVA_VERSION_BUILD 14
ENV JAVA_BASE /usr/local/java
ENV JAVA_HOME $JAVA_BASE/jdk
ENV PATH $PATH:$JAVA_HOME/bin

# Install software
RUN apk --update add \
      curl \
      bash && \
    curl --silent --insecure --location --remote-name "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" &&\
    curl --silent --insecure --location --remote-name "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" &&\
    apk add --allow-untrusted \
      glibc-2.21-r2.apk \
      glibc-bin-2.21-r2.apk &&\
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib &&\
    mkdir -p $JENKINS_HOME $JENKINS_VOL/plugins $JAVA_BASE &&\
    curl --silent --insecure --location --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar zxf - -C $JAVA_BASE &&\
    ln -s $JAVA_BASE/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME} &&\
    curl --silent --location http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war --output ${JENKINS_HOME}/jenkins.war &&\
    addgroup ${JENKINS_GROUP} &&\
    adduser -h ${JENKINS_HOME} -D -s /bin/bash -G ${JENKINS_GROUP} ${JENKINS_USER} &&\
    chown -R ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_HOME} ${JENKINS_VOL}

# Listen for main web interface (8080/tcp) and attached slave agents (50000/tcp)
EXPOSE 8080 50000

# Expose volumes
VOLUME ["${JENKINS_VOL}"]

COPY jenkins.sh /usr/local/bin/jenkins.sh

USER ${JENKINS_USER}

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
CMD [""]
