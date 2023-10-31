ARG agent_version=3192.v713e3b_039fb_e-1

FROM ubuntu:20.04 as sessionmanagerplugin

RUN apt-get update \
    && apt-get install -y curl \
    && curl -Lo "session-manager-plugin.deb" "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
    && dpkg -i "session-manager-plugin.deb"


FROM jenkins/inbound-agent:${agent_version}-alpine-jdk11

# Elevate
USER root
#  need to install both npm and nodejs
ARG nodejs_version=16.20.2-r0
ARG npm_version=8.1.3-r0
ARG grep_version=3.4-r0
ARG awscli_version=2.13.5-r0
ARG docker_version=23.0.6-r6
ARG dockerbuildx_version=0.10.4-r9

COPY --from=sessionmanagerplugin /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/

RUN apk update && apk upgrade

RUN apk --no-cache add -X https://dl-cdn.alpinelinux.org/alpine/v3.16/main -u alpine-keys \
  && apk --no-cache add --update nodejs=${nodejs_version} --repository=https://dl-cdn.alpinelinux.org/alpine/v3.16/main  \ 
  && apk --no-cache add --update grep=${grep_version} --repository=https://dl-cdn.alpinelinux.org/alpine/v3.12/main  \ 
  && apk --no-cache add --update npm=${npm_version} --repository=https://dl-cdn.alpinelinux.org/alpine/v3.15/main  \
  && apk --no-cache add --update docker=${docker_version} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.18/community \
  && apk --no-cache add --update docker-cli-buildx=${dockerbuildx_version} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.18/community \
  && apk add --update aws-cli=${awscli_version} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.18/community \
  && rm -rf /var/lib/apt/lists/*

#Install AWS CLI v2 \ slim down image
RUN apk --no-cache add groff expect
  
RUN npm install -g gulp

USER jenkins