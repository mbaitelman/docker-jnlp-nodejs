ARG agent_version=4.6-1
ARG npm_version=14.15.4-r0
FROM jenkins/inbound-agent:${agent_version}-alpine

# Elevate
USER root
# Only need to install npm, nodejs is included
RUN apk add --update npm=${npm_version} --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
  && rm -rf /var/lib/apt/lists/*
  
RUN npm install -g gulp  

USER jenkins
