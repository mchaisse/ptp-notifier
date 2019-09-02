#!/bin/bash
set -e

# start the cron jobs
if [[ "$OSTYPE" == "linux-musl" ]]; then # Alpine
  crond
else # Gnu
  cron
fi

# append "nothing" to the file which also modifies the last update timestamp
# which forces a copy-on-write
# see https://gist.github.com/sudo-bmitch/f91a943174d6aff5a57904485670a9eb for more details
: >> /var/log/ptp-cron.log
: >> /var/log/ptp-notifier.log

# tail cron and scripts logs
tail -qF /var/log/ptp-cron.log /var/log/ptp-notifier.log
