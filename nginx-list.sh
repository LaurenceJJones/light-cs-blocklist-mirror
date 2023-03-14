#!/bin/sh
while true;
do
    RES=$(/usr/bin/curl -s -H "X-Api-Key: $CROWDSEC_API_KEY" "$CROWDSEC_API_URL/v1/decisions");
    /usr/bin/jq --jsonargs -r '.[].value' "$RES" > /tmp/list.txt;
    if [ "$(md5sum /tmp/list.txt | awk '{print $1}')" != "$(md5sum /usr/share/nginx/html/list.txt | awk '{print $1}')" ]; then
        mv /tmp/list.txt /usr/share/nginx/html/list.txt ;
    fi
    sleep 10;
done