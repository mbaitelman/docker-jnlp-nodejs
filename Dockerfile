ARG agent_version=4.6-1
FROM jenkins/inbound-agent:${agent_version}-alpine

# Elevate
USER root
# Only need to install npm, nodejs is included
ARG npm_version=14.15.4-r0
ARG grep_version=3.6-r0
RUN apk add --update npm=${npm_version} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
  && apk add --update grep=${grep_version} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
  && rm -rf /var/lib/apt/lists/*
  
RUN npm install -g gulp  

USER jenkins
