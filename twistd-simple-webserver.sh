#!/bin/bash
 
echo "::: Starting twistd webserver in $(pwd) ..."
twistd --nodaemon --pidfile /tmp/twistd_web.pid web --port tcp:8080 --path . -l -
echo "::: twistd execution finished, goodbye."
