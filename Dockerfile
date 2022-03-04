ARG agent_version=4.6-1
FROM jenkins/inbound-agent:${agent_version}-alpine as install

# Elevate
USER root
#  need to install both npm and nodejs
ARG nodejs_version=16.13.2-r1
ARG npm_version=12.22.10-r0
ARG grep_version=3.4-r0
ARG aws_version=1.18.55-r0
ARG docker_version=20.10.3-r0

RUN apk add --update grep=${grep_version} --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  && apk add --update curl --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/main \
  && apk add --update nodejs=${nodejs_version} --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \ 
  && apk add --update npm=${npm_version} --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
  && apk add --update docker=${docker_version} --repository=http://dl-cdn.alpinelinux.org/alpine/latest-stable/community \
  && rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm awscliv2.zip
  
RUN npm install -g gulp
USER jenkins

FROM install as verify
RUN node -v 
RUN npm -v
RUN grep --version
RUN aws --version
RUN docker --version

FROM install as deploy
