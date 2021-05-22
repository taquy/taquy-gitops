# syntax=docker/dockerfile:1
FROM python

USER root
WORKDIR /app
ARG schedule="* * * * *"

# Create volumes
RUN mkdir -p /data/backup/archives /data/backup/logs /data/backup/conf /root/.aws/
VOLUME ["/data/backup/archives", "/data/backup/logs", "/data/backup/conf", "/root/.aws/"]

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Install libraries
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Copy config files
COPY . .
COPY ./backup.conf /data/backup/conf
RUN chmod a+x /app/backup.py
RUN chmod a+x /app/backup-cron.py

# Cronjob
CMD ["/usr/local/bin/python3", "/app/backup-cron.py"]