FROM node:8.8

WORKDIR /berend

ADD . /berend

RUN yarn install
