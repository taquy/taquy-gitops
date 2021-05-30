FROM jenkins/jenkins:centos7

LABEL maintainer="taquy.pb@gmail.com"

USER root
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN mkdir -p /var/jenkins_home/.aws
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins

VOLUME [ "/var/log/jenkins", "/var/cache/jenkins", "/var/jenkins_home" ]

RUN yum install -y yum-utils
RUN curl -fsSL https://get.docker.com/ | sh

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

USER jenkins

ENV JENKINS_USER root
ENV JENKINS_PASS root1234

ENV JAVA_OPTS="-Xmx8192m -Djenkins.install.runSetupWizard=false"
ENV JENKINS_OPTS="--handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war --argumentsRealm.roles.user=admin --argumentsRealm.passwd.admin=admin --argumentsRealm.roles.admin=admin"

COPY plugins.txt /usr/share/jenkins/plugins.txt

RUN cat /usr/share/jenkins/plugins.txt | /usr/local/bin/install-plugins.sh