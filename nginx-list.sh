#!/bin/sh
## Keep track of versioning for the useragent
VER="1.0"
if [ -z "$USERAGENT" ]; then
    echo "USERAGENT is not set, defaulting to 'light-blocklist-mirror/$VER'"
    USERAGENT="light-blocklist-mirror/$VER"
fi
if [ -z "$UPDATE_FREQUENCY" ]; then
	echo "UPDATE_FREQUENCY is not set, defaulting to 10"
	UPDATE_FREQUENCY=10
fi
while true;
do
    /usr/bin/curl -s -A "$USERAGENT" -H "X-Api-Key: $CROWDSEC_API_KEY" "$CROWDSEC_API_URL/v1/decisions" | /usr/bin/jq -r '.[].value' > /tmp/list.txt;
    if [ ! -f /usr/share/nginx/html/list.txt ]; then
        /bin/mv /tmp/list.txt /usr/share/nginx/html/list.txt ;
    elif [ "$(/usr/bin/md5sum /tmp/list.txt | awk '{print $1}')" != "$(/usr/bin/md5sum /usr/share/nginx/html/list.txt | awk '{print $1}')" ]; then
        /bin/mv /tmp/list.txt /usr/share/nginx/html/list.txt ;
    fi
    sleep "$UPDATE_FREQUENCY";
done