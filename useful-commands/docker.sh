# Docker

# Install Docker on Ubuntu via .deb package
# deb package download page: (under `SYSTEM_NAME/pool/stable/`)
# https://download.docker.com/linux/ubuntu/dists/
# other ways:
# https://docs.docker.com

# lingo 相关概念
## image 镜像
## container 容器
## volume 数据卷(数据存放)

# relationship 关系
## download(or from local) a image 下载(或从本地安装) 一个镜像
## create container from image 创建一个对应镜像的容器
## mount a volume into a container 为容器挂载一个存放保留数据的数据卷
# relationship like OOP (有面向对象编程思想理解)
# Image is Class (镜像是类)
# Container is Instance (容器是实例)

# list all images in local
sudo docker images
sudo docker image ls

# search images online
sudo docker search $keyword

# run a container from an image 从一个镜像中运行一个容器
sudo docker run --name $CONTAINER_NAME [OPTIONS...] $IMAGE_NAME $COMMAND $ARGUMENTS
# useful options:
## -i Keep stdin open even if not attached
## -d Run container in background
## -t allocate a pseudo-TTY

# attach to a running container
sudo docker exec -it $CONTAINER_NAME /bin/bash

# list running container
sudo docker ps # -a for all

# start and stop container
sudo docker start/stop $CONTAINER_NAME
# kill all containers
sudo docker kill $(docker ps -q)

# remove all containers
sudo docker rm $(docker ps -q -a) # and -f for force remove even if it is running

# difference between kill(just now) and stop(send SIGTERM and wait it at most 10 seconds)

# clean up all things (Boom shakalaka~~)
sudo docker system prune -a
