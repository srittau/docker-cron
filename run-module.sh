#!/usr/bin/env bash

set -e

if test -f /app/env; then
    set -a
    source "/app/env"
    set +a
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
    echo -e "$MAIL_TEXT" | timeout 30 msmtp -C /app/msmtprc $MAIL_RECEIVERS
fi
