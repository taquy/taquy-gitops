FROM docker-compose:aarch64

RUN docker run --rm --entrypoint="script/build/linux-entrypoint" -v $(pwd)/dist:/code/dist -v $(pwd)/.git:/code/.git "docker-compose:armhf"
RUN cp dist/docker-compose-Linux-armv7l /usr/local/bin/docker-compose
RUN chown root:root /usr/local/bin/docker-compose
RUN chmod 0755 /usr/local/bin/docker-compose
RUN docker-compose version

ENTRYPOINT [ "executable" ]