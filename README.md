A lightweight nginx image that serves a crowdsec blocklist similar to the [blocklist-mirror](https://github.com/crowdsecurity/cs-blocklist-mirror)

When serving just a basic blocklist, there a better way to serve the list than having a binary that running uses 60MB RAM. This repo holds a Dockerfile that builds a nginx image that has a background task that curl the decision endpoint and creates a file called list.txt on port 80. In my testing this reduced 60MB ram down to 6mb as nginx is not holding the decision in memory like the blocklist mirror does.

The environment variables you can provide the container image are:

* AUTH_TYPE - The type of authentication for nginx to use. Default is none but you can provide basic or ip_based
* USERNAME - The username to use for basic authentication
* PASSWORD - The password to use for basic authentication
* IP - A list of IPs to allow access to the list. This is a comma separated list

You can also provide these environment variables to the container image and nginx-list.sh script if running serperately.

* CROWDSEC_API_URL - The URL to the crowdsec API
* CROWDSEC_API_KEY - The API key to use to authenticate to the API
* UPDATE_FREQUENCY - The frequency to update the list. Default is 5 minutes

If you wish to run this outside of a container context, just create a service file example

```
[Unit]
Description=Background task to update nginx list.txt

[Service]
Environment=CROWDSEC_API_URL=http://127.0.0.1:8080
Environment=CROWDSEC_API_KEY=1234
ExecStart=/usr/bin/nginx-list.sh

[Install]
WantedBy=multi-user.target
```

If planning to run script outside of a container, you will need to install the following
* JQ - https://stedolan.github.io/jq/
* curl - https://curl.se/
* sed - https://www.gnu.org/software/sed/
* awk - https://www.gnu.org/software/gawk/
* md5sum - https://www.gnu.org/software/coreutils/manual/html_node/md5sum-invocation.html

Please note that this is not a supported CrowdSec product and is provided as is. If you have any questions or issues, please open an issue on this repo.