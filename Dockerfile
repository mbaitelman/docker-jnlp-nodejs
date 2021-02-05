ARG agent_version=4.6-1
FROM jenkins/inbound-agent:${agent_version}-alpine

RUN apk add --update nodejs=12.20.1-r0
