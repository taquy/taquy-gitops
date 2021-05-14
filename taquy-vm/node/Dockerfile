FROM node:16-alpine3.11


ENV NODE_PATH=/app/node_modules
ENV PATH=$PATH:/app/node_modules/.bin
ENV PATH=$PATH:"/app/node_modules/ffmpeg-static/bin/linux/x64:${PATH}"

RUN apt-get update || : && apt-get install python -y
RUN apt install python-pip -y

RUN apt install imagemagick ghostscript poppler-utils -y
RUN cp ./imagemagick-policy.xml /etc/ImageMagick-6/policy.xml

RUN apt install ffmpeg -y
RUN apt install libmp3lame-dev -y

RUN pip install update youtube-dl
RUN yarn global add pm2

RUN mkdir -p /data/tmp