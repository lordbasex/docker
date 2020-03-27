FROM ubuntu
MAINTAINER Federico Pereira <fpereira@cnsoluciones.com>
RUN apt-get update && apt-get -y install jp2a
ADD https://raw.githubusercontent.com/lordbasex/Docker/master/docker-super-mario-run/docker-super-mario-run.jpg /tmp/docker-super-mario-run.jpg
ENV TERM xterm-256color
CMD clear && jp2a /tmp/docker-super-mario-run.jpg && echo "\n Hola Mundo \n URL: https://github.com/lordbasex/Docker/tree/master/docker-super-mario-run \n"
