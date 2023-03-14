#!/bin/sh
while true;
do
    /usr/bin/curl -s -H "X-Api-Key: $CROWDSEC_API_KEY" "$CROWDSEC_API_URL/v1/decisions" | /usr/bin/jq --jsonargs -r '.[].value' > /tmp/list.txt;
    #check if /usr/share/nginx/html/list.txt exists
    if [ ! -f /usr/share/nginx/html/list.txt ]; then
        mv /tmp/list.txt /usr/share/nginx/html/list.txt ;
    elif [ "$(md5sum /tmp/list.txt | awk '{print $1}')" != "$(md5sum /usr/share/nginx/html/list.txt | awk '{print $1}')" ]; then
        mv /tmp/list.txt /usr/share/nginx/html/list.txt ;
    fi
    sleep 10;
done