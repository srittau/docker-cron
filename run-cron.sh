#!/usr/bin/env bash

set -e

stop() {
    killall tail
}

trap stop SIGTERM SIGINT

touch /var/log/script.log
cron
tail -f /var/log/script.log &

wait $!
