FROM jenkins/jenkins:2.277.2-lts-jdk11
USER root
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN apt-get update
RUN apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.24.6 docker-workflow:1.26 dashboard-view:2.15 cloudbees-folder:6.15 monitoring:1.87.0 disk-usage:0.28 perfpublisher:8.09 job-dsl:1.77 build-pipeline-plugin:1.5.8 jenkins-multijob-plugin:1.36 workflow-aggregator:2.6 scm-api:2.6.4 git:4.7.1 github-pullrequest:0.2.8 view-job-filters:2.3"
