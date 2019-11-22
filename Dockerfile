FROM ubuntu:16.04 as build

MAINTAINER Tom Llewellyn-Smith <tom@stellar.org>

ADD . /app/src

WORKDIR /app/src

RUN apt-get update && apt-get install -y curl git apt-transport-https && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/node_10.x xenial main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn && \
    /app/src/jenkins.bash

FROM nginx:1.17

COPY --from=build /app/src/dist/* /usr/share/nginx/html/laboratory/
