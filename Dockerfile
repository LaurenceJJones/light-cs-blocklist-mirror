FROM nginx:alpine

RUN apk update && apk add curl && apk add jq

COPY docker_start.sh /docker_start.sh

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["/bin/sh", "/docker_start.sh"]
