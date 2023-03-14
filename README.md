When serving just a basic blocklist, there a better way to serve the list than having a binary that running uses 60MB RAM. This repo holds a Dockerfile that builds a nginx image that has a background task that curl the decision endpoint and creates a file called list.txt on port 80. In my testing this reduced 60MB ram down to 6mb as nginx is not holding the decision in memory like the blocklist mirror does.

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

`/usr/bin/nginx-list.sh` is just the background task noted by the `/bin/sh -c` within `docker_start.sh`
