#!/usr/bin/env bash

set -e

if test -f /app/env; then
    TMP="$(mktemp env.XXXXXXXXXX)"
    sed -e s/=/=\'/ /app/env | sed -e s/$/\'/ >"${TMP}"
    set -a
    source "${TMP}"
    set +a
    rm "${TMP}"
fi

export PYTHONPATH=/app/src

LOGFILE=/var/log/script.log
MODULE_NAME="$1"
shift

echo "***** $(date -Iseconds) Running $MODULE_NAME" >>"$LOGFILE"
TMP=$(mktemp "cron-$MODULE_NAME.XXXXXXXXXX")
/app/virtualenv/bin/python -m "$MODULE_NAME" "$@" 2>&1 | tee -a "$LOGFILE" "$TMP"
OUTPUT="$(cat "$TMP")"
rm "${TMP}"

if test -n "$MAIL_RECEIVERS" -a -n "$OUTPUT"; then
    MAIL_TEXT="Subject: cron output from $MODULE_NAME\r\nFrom: $MAIL_SENDER\r\nTo: $MAIL_RECEIVERS\r\n\r\n${OUTPUT}"
    echo -e "$MAIL_TEXT" | msmtp $MAIL_RECEIVERS
fi
