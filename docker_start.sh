#!/bin/sh
if [ -z "$CROWDSEC_API_KEY" ]; then
    echo "CROWDSEC_API_KEY is not set"
    exit 1
fi

if [ -z "$CROWDSEC_API_URL" ]; then
    echo "CROWDSEC_API_URL is not set"
    exit 1
fi

if [ -z "$AUTH_TYPE" ]; then
    echo "AUTH_TYPE is not set, defaulting to none"
else
    if [ "$AUTH_TYPE" = "basic" ]; then
	if [ -z "$USERNAME" ]; then
	    echo "USERNAME is not set"
	    exit 1
	fi
	if [ -z "$PASSWORD" ]; then
	    echo "PASSWORD is not set"
	    exit 1
	fi
	/usr/bin/htpasswd -b -c /etc/nginx/.htpasswd "$USERNAME" "$PASSWORD"
	/bin/sed -i "s/#auth_basic/auth_basic/g" /etc/nginx/conf.d/default.conf
	/bin/sed -i "s/#auth_basic_user_file/auth_basic_user_file/g" /etc/nginx/conf.d/default.conf
    elif [ "$AUTH_TYPE" = "ip_based" ]; then
	if [ -z "$IP" ]; then
	    echo "AUTH_TYPE is set to ip_based but no IP is not set"
	    exit 1
	fi
	for ip in $(echo "$IP" | sed "s/,/ /g")
	do
	    echo "allow $ip;" >> /etc/nginx/conf.d/allow.conf
	done
	echo "deny all;" >> /etc/nginx/conf.d/allow.conf
    elif [ "$AUTH_TYPE" = "none" ]; then
	echo "AUTH_TYPE is set to none, no authentication will be used"
    else
	echo "AUTH_TYPE is not set to basic, ip_based or none"
	exit 1
    fi
fi

/bin/sh /nginx-list.sh&
/usr/sbin/nginx -g "daemon off;"
