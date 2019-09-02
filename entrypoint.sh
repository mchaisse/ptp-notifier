#!/bin/bash
set -e

# export env vars for the cron job
if [[ "$OSTYPE" == "linux-gnu" ]]; then # Gnu
  declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /tmp/container.env
fi

if [[ -z "${PTP_USERNAME}" || -z "${PTP_PASSWORD}" || -z "${PTP_PASSKEY}" || -z "${SLACK_API_TOKEN}" ]]
then
  echo "ERROR: Environment variables missing..."
  exit 1
fi

[[ -z "${OMDB_API_KEY}" ]] && echo "Warning: OMDB api key is missing, ratings will be ignored."

# start redis server
redis-server --daemonize yes

exec "$@"
