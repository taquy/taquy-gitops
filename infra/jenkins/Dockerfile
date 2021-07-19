FROM jenkins/jenkins:latest AS BUILD_STAGE

LABEL maintainer="taquy.pb@gmail.com"

ARG ROOT_PASSWORD="root1234"

ARG DEBIAN_FRONTEND=noninteractive

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
RUN cat /etc/*release
RUN mkdir /var/log/jenkins \
  && mkdir /var/cache/jenkins \
  && mkdir -p /var/jenkins_home/.aws \
  && chown -R jenkins:jenkins /var/log/jenkins \
  && chown -R jenkins:jenkins /var/cache/jenkins \
  && apt-get update -y \
  && apt install -y jq \
  # install docker
  && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
  && curl -4fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  && echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update -y \
  && apt-get install -y docker-ce docker-ce-cli containerd.io \
  # install awscli
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip -qq awscliv2.zip \
  && ./aws/install  \
  # change root password
  && echo "root:$ROOT_PASSWORD" | chpasswd \
  # install ecr helper (for jenkins node)
  && apt install -y amazon-ecr-credential-helper \
  # install docker compose
  && curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

VOLUME [ "/var/log/jenkins", "/var/cache/jenkins", "/var/jenkins_home" ]

USER jenkins

RUN echo "Dependencies check..."
RUN docker-compose --version \
  && docker --version \
  && aws --version

RUN mkdir -p ~/.docker/ \
  && echo "{\"credsStore\": \"ecr-login\"}" > ~/.docker/config.json