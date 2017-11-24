FROM node:8.1.4

WORKDIR /berend

# Copy the current directory contents into the container at /app
ADD . /berend

RUN yarn install
