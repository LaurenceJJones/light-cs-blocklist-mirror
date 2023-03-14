A lightweight nginx image that serves a crowdsec blocklist similar to the [blocklist-mirror](https://github.com/crowdsecurity/cs-blocklist-mirror)

When serving just a basic blocklist, there a better way to serve the list than having a binary that running uses 60MB RAM. This repo holds a Dockerfile that builds a nginx image that has a background task that curl the decision endpoint and creates a file called list.txt on port 80. In my testing this reduced 60MB ram down to 6mb as nginx is not holding the decision in memory like the blocklist mirror does.

The environment variables you can provide the container image are:

* `AUTH_TYPE` - The type of authentication for nginx to use. Default is none but you can provide basic or ip_based
* `USERNAME` - The username to use for basic authentication
* `PASSWORD` - The password to use for basic authentication
* `IP` - A list of IPs to allow access to the list. This is a comma separated list

You can also provide these environment variables to the container image and nginx-list.sh script if running serperately.

* `CROWDSEC_API_URL` - The URL to the crowdsec API
* `CROWDSEC_API_KEY` - The API key to use to authenticate to the API
* `UPDATE_FREQUENCY` - The frequency to update the list. Default is 10 seconds (To improve performance for nginx the file will only update if the md5sum of the file changes)

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
* `JQ` - https://stedolan.github.io/jq/
* `curl` - https://curl.se/
* `sed` - https://www.gnu.org/software/sed/
* `awk` - https://www.gnu.org/software/gawk/
* `md5sum` - https://www.gnu.org/software/coreutils/manual/html_node/md5sum-invocation.html

Please note that this is not a supported CrowdSec product and is provided as is. If you have any questions or issues, please open an issue on this repo.


---
---

Benchmarking
------------
Nginx and my script running in a container with 1 CPU and 1GB RAM

```
This is ApacheBench, Version 2.3 <$Revision: 1901567 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 178.62.3.89 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        nginx
Server Hostname:        178.62.3.89
Server Port:            80

Document Path:          /list.txt
Document Length:        469636 bytes

Concurrency Level:      10
Time taken for tests:   158.635 seconds
Complete requests:      10000
Failed requests:        0
Keep-Alive requests:    9996
Total transferred:      4699109980 bytes
HTML transferred:       4696360000 bytes
Requests per second:    63.04 [#/sec] (mean)
Time per request:       158.635 [ms] (mean)
Time per request:       15.864 [ms] (mean, across all concurrent requests)
Transfer rate:          28927.79 [Kbytes/sec] received

Connection Times (ms)
min  mean[+/-sd] median   max
Connect:        0    0   0.9      0      38
Processing:    26  158 166.9    123    3159
Waiting:       12   25   9.7     25     433
Total:         26  158 166.9    123    3159

Percentage of the requests served within a certain time (ms)
50%    123
66%    155
75%    180
80%    199
90%    273
95%    372
98%    611
99%    934
100%   3159 (longest request)
```

Crowdsec blocklist-mirror running with 1 CPU and 1GB RAM

```
This is ApacheBench, Version 2.3 <$Revision: 1901567 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 178.62.3.89 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:
Server Hostname:        178.62.3.89
Server Port:            81

Document Path:          /list.txt
Document Length:        469621 bytes

Concurrency Level:      10
Time taken for tests:   969.423 seconds
Complete requests:      10000
Failed requests:        0
Keep-Alive requests:    0
Total transferred:      4697180000 bytes
HTML transferred:       4696210000 bytes
Requests per second:    10.32 [#/sec] (mean)
Time per request:       969.423 [ms] (mean)
Time per request:       96.942 [ms] (mean, across all concurrent requests)
Transfer rate:          4731.78 [Kbytes/sec] received

Connection Times (ms)
min  mean[+/-sd] median   max
Connect:       14   32  99.6     21    3050
Processing:   194  938 262.7    879    2340
Waiting:       95  632 220.8    590    2030
Total:        215  969 282.1    902    4031

Percentage of the requests served within a certain time (ms)
50%    902
66%    976
75%   1032
80%   1078
90%   1292
95%   1634
98%   1882
99%   1984
100%   4031 (longest request)
```

Conclusion
----------
As you can see, the nginx list is much faster than the crowdsec list. This is because the crowdsec list is generated on the fly and is not cached. The nginx list is cached and only updates when the md5sum of the file changes. This means that the nginx list is much faster and more efficient than the crowdsec list. If you want a faster and smaller footprint then use the nginx list. Keep in mind there is no other formats other than plain at the moment.