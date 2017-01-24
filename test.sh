#!/usr/bin/env bash
#
# Simple test script that sees if the SABnzbd server is up within a certain number
# of seconds (TOTAL_ATTEMPTS * SLEEP_TIME). If it isn't up in time or the HTTP
# code returned is not 200, then it exits out with an error code.

TOTAL_ATTEMPTS=10
SLEEP_TIME=6

function connect_server {
    http_code=$(curl -sL -w "%{http_code}\\n" "http://localhost:8080/" -o /dev/null)
    curl_exit=$?
}

attempts=0
until [ $attempts -ge $TOTAL_ATTEMPTS ]
do
    connect_server
    [ "$curl_exit" == "0" ] && break
    attempts=$[$attempts+1]
    sleep $SLEEP_TIME
done

if [ "$http_code" != "200" ]
then
    echo "Received HTTP $http_code from SABnzbd port (last curl exit code: $curl_exit)"
    exit 1
fi
