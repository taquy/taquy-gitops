FROM node:16-alpine3.11

ENV NODE_PATH=/app/node_modules
ENV PATH=$PATH:/app/node_modules/.bin
ENV PATH=$PATH:"/app/node_modules/ffmpeg-static/bin/linux/x64:${PATH}"

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools youtube-dl

RUN apk --update add imagemagick ghostscript poppler-utils
RUN apk add --no-cache ffmpeg lame-dev

COPY ./imagemagick-policy.xml /etc/ImageMagick-6/policy.xml

RUN yarn global add pm2

RUN mkdir -p /data/tmp