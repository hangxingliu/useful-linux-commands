# Usage example:
#  sudo docker build -t hangxingliu/useful-linux-commands .
#  sudo docker run -p 80:10765 -u node -m 256M --memory-swap 1G -d \
#    --name my-usefule-linux-commands hangxingliu/useful-linux-commands
#
# Maintenance example:
#  sudo docker exec -u root -it my-usefule-linux-commands /bin/bash
#
# TODO: https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md

FROM node:8
LABEL maintainer="hangxingliu@gmail.com"

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

RUN npm install pm2 -g

RUN mkdir -p /webapp
WORKDIR /webapp

# HEALTHCHECK ...

COPY package*.json ./
RUN npm install --production
ADD . ./

EXPOSE 10765
CMD pm2-docker ecosystem.yaml
