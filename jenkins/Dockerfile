FROM jenkins/jenkins:2.277.4-lts-centos7

USER root
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins

USER jenkins
ENV JAVA_OPTS="-Xmx8192m -Djenkins.install.runSetupWizard=false --argumentsRealm.passwd.admin=root1234 --argumentsRealm.roles.user=root --argumentsRealm.roles.admin=admin --httpPort=8080"
ENV JENKINS_OPTS="--handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war"

COPY plugins.txt /usr/share/jenkins/plugins.txt

RUN cat /usr/share/jenkins/plugins.txt | /usr/local/bin/install-plugins.sh