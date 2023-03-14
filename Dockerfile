FROM nginx:alpine

RUN apk update && apk add curl && apk add jq && apk add apache2-utils && rm -rf /var/cache/apk/*

COPY docker_start.sh /docker_start.sh

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["/bin/sh", "/docker_start.sh"]
