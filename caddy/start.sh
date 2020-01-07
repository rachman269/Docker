#!/bin/sh
set -eux

# Environment variables.
ENV=${ENV:-development}
TZ=${TZ:-UTC}
EMAIL=${EMAIL:-""}
EXTRA_ARGS=""

# Set timezone if not UTC
if [ ${TZ} != "UTC" ]; then
	cp /usr/share/zoneinfo/${TZ} /etc/localtime
	echo ${TZ} > /etc/timezone
fi

# Extra args for production
if [ ${ENV} == "production" ]; then
	EXTRA_ARGS="-agree -email ${EMAIL}"
fi

# First arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- caddy "$@"
fi

exec gosu caddy "$@" ${EXTRA_ARGS}