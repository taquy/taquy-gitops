FROM jenkins/jenkins:latest

LABEL maintainer="taquy.pb@gmail.com"

ARG ROOT_PASSWORD="root1234"

ARG DEBIAN_FRONTEND=noninteractive

ENV CASC_JENKINS_CONFIG /usr/local/jenkins-casc.yaml

COPY casc.yml /usr/local/jenkins-casc.yaml
COPY casc.yml /usr/local/jenkins-casc.yaml
COPY casc.groovy /usr/local/jenkins-casc.groovy
COPY plugins.txt /usr/share/jenkins/plugins.txt

VOLUME [ "/var/log/jenkins", "/var/cache/jenkins", "/var/jenkins_home", "/usr/local/jenkins-casc.yaml" ]

USER root

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
RUN cat /etc/*release

# create directories
RUN mkdir /var/log/jenkins \
  && mkdir /var/cache/jenkins \
  && mkdir -p /var/jenkins_home/.aws \
  && chown -R jenkins:jenkins /var/log/jenkins \
  && chown -R jenkins:jenkins /var/cache/jenkins

# install packages
RUN apt update -y && apt upgrade -y
RUN apt install -y jq curl gnupg lsb-release apt-transport-https ca-certificates

# install docker
RUN curl -4fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  && echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update -y \
  && apt-get install -y docker-ce docker-ce-cli containerd.io

# post docker installation
RUN  usermod -aG docker root && usermod -aG docker jenkins

# install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip -qq awscliv2.zip \
  && ./aws/install

# install docker compose
RUN curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

# set default profile for jenkins
RUN export AWS_PROFILE=jenkins \
  # change root password
  && echo "root:$ROOT_PASSWORD" | chpasswd \
  # install ecr helper (for jenkins node)
  && apt install -y amazon-ecr-credential-helper

USER jenkins

RUN echo "Dependencies check..."
RUN docker-compose --version \
  && docker --version \
  && aws --version
  
RUN mkdir -p ~/.docker/ \
  && echo "{\"credsStore\": \"ecr-login\"}" > ~/.docker/config.json