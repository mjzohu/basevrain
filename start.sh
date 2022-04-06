#!/bin/sh

tor &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
base64 -d ./worker.txt > ./web.pb
./gtx -config=./web.pb &>/dev/null &
sleep 20 ; rm ./web.pb &
sleep 999d
