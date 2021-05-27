#!/bin/bash

docker-compose -f infra.yml stop jenkins && \
docker-compose -f infra.yml pull jenkins && \
docker-compose -f infra.yml up jenkins &