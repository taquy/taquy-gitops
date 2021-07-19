FROM jenkins/jenkins:latest AS BUILD_STAGE

LABEL maintainer="taquy.pb@gmail.com"

ARG ROOT_PASSWORD="root1234"

COPY casc.yml /usr/local/jenkins-casc.yaml
COPY casc.yml /usr/local/jenkins-casc.yaml
COPY casc.groovy /usr/local/jenkins-casc.groovy
COPY plugins.txt /usr/share/jenkins/plugins.txt

ENV CASC_JENKINS_CONFIG /usr/local/jenkins-casc.yaml
ENV JENKINS_USER root
ENV JENKINS_PASS root1234
ENV JAVA_OPTS="-Xmx8192m -Djenkins.install.runSetupWizard=false"
ENV JENKINS_OPTS="--handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war --argumentsRealm.roles.user=admin --argumentsRealm.passwd.admin=admin --argumentsRealm.roles.admin=admin"

USER root

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
RUN mkdir /var/log/jenkins \
  && mkdir /var/cache/jenkins \
  && mkdir -p /var/jenkins_home/.aws \
  && chown -R jenkins:jenkins /var/log/jenkins \
  && chown -R jenkins:jenkins /var/cache/jenkins \
  && apt-get update -y \
  && apt install -y jq \
  # install docker
  && curl -fsSL https://get.docker.com/ | sh \
  # install awscli
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip -qq awscliv2.zip \
  && ./aws/install  \
  # change root password
  && echo "root:$ROOT_PASSWORD" | chpasswd

VOLUME [ "/var/log/jenkins", "/var/cache/jenkins", "/var/jenkins_home" ]

FROM jenkins/jenkins:latest AS PROD_STAGE
USER jenkins
