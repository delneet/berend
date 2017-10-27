FROM node:8.1.4

RUN mkdir /app
RUN apt-get -y update

ADD . /app

WORKDIR /app
RUN cd /app && npm install
