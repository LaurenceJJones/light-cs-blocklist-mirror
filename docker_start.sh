if [ -z "$CROWDSEC_API_KEY" ]; then
    echo "CROWDSEC_API_KEY is not set"
    exit 1
fi

if [ -z "$CROWDSEC_API_URL" ]; then
    echo "CROWDSEC_API_URL is not set"
    exit 1
fi

/bin/sh -c "while true; do /usr/bin/curl -s -H 'X-Api-Key: $CROWDSEC_API_KEY' $CROWDSEC_API_URL/v1/decisions | /usr/bin/jq -r '.[].value' > /usr/share/nginx/html/list.txt ; sleep 10; done"&

nginx -g "daemon off;"
