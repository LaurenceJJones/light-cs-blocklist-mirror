FROM docker://nginx:alpine

RUN apk update && apk add curl && apk add jq

COPY docker_start.sh /docker_start.sh

ENTRYPOINT ["/bin/sh", "/docker_start.sh"]
