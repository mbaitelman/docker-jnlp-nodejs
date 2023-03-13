ARG agent_version=4.10-3

FROM ubuntu:20.04 as sessionmanagerplugin

RUN apt-get update \
    && apt-get install -y curl \
    && curl -Lo "session-manager-plugin.deb" "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
    && dpkg -i "session-manager-plugin.deb"


FROM jenkins/inbound-agent:${agent_version}-alpine-jdk11 as install

# Elevate
USER root
#  need to install both npm and nodejs
ARG nodejs_version=16.13.2-r1
ARG npm_version=12.22.10-r0
ARG grep_version=3.4-r0
ARG aws_version=1.18.55-r0
ARG docker_version=20.10.3-r0

RUN apk --no-cache add -X https://dl-cdn.alpinelinux.org/alpine/v3.16/main -u alpine-keys \
  && apk --no-cache add --update nodejs=${nodejs_version} --repository=https://dl-cdn.alpinelinux.org/alpine/v3.16/main  \ 
  && apk --no-cache add --update grep=${grep_version} --repository=https://dl-cdn.alpinelinux.org/alpine/v3.12/main  \ 
  && apk --no-cache add --update npm=${npm_version} --repository=https://dl-cdn.alpinelinux.org/alpine/v3.15/main  \
  && apk --no-cache add --update docker=${docker_version} --repository=http://dl-cdn.alpinelinux.org/alpine/latest-stable/community \
  && rm -rf /var/lib/apt/lists/*

#Install AWS CLI v2 \ slim down image
RUN apk --no-cache add curl groff expect && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${awscli_version}.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf awscliv2.zip  ./aws \
  && apk --no-cache del \
      curl \
  && rm -rf /var/cache/apk/*

RUN npm install -g gulp
USER jenkins

FROM install as verify
RUN node -v 
RUN npm -v
RUN grep --version
RUN aws --version
RUN docker --version

FROM install as deploy
