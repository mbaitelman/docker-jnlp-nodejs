ARG agent_version=4.6-1
FROM jenkins/inbound-agent:${agent_version}-alpine

# Elevate
USER root
#  need to install both npm and nodejs
ARG nodejs_version=16.13.0-r0
ARG npm_version=8.1.3-r0
ARG grep_version=3.7-r0
ARG aws_version=1.18.55-r0

RUN apk add --update nodejs=${nodejs_version} --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \ 
  && apk add --update npm=${npm_version} --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
  && apk add --update grep=${grep_version} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
  && apk add --update aws-cli=${aws_version} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
  && rm -rf /var/lib/apt/lists/*
  
RUN npm install -g gulp

USER jenkins