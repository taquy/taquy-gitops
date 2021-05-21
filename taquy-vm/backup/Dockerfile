# syntax=docker/dockerfile:1
FROM python:3.8-slim-buster

USER root
WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .

RUN apt-get update && apt-get -y install cron

RUN echo "* * * * * echo \"Hello world\"" >> backup.job 2>&1