#!/bin/sh
if [ -z "$UPDATE_FREQUENCY" ]; then
	echo "UPDATE_FREQUENCY is not set, defaulting to 10"
	UPDATE_FREQUENCY=10
fi
while true;
do
    /usr/bin/curl -s -H "X-Api-Key: $CROWDSEC_API_KEY" "$CROWDSEC_API_URL/v1/decisions" | /usr/bin/jq --jsonargs -r '.[].value' > /tmp/list.txt;
    if [ ! -f /usr/share/nginx/html/list.txt ]; then
        /bin/mv /tmp/list.txt /usr/share/nginx/html/list.txt ;
    elif [ "$(/usr/bin/md5sum /tmp/list.txt | awk '{print $1}')" != "$(/usr/bin/md5sum /usr/share/nginx/html/list.txt | awk '{print $1}')" ]; then
        /bin/mv /tmp/list.txt /usr/share/nginx/html/list.txt ;
    fi
    sleep "$UPDATE_FREQUENCY";
done