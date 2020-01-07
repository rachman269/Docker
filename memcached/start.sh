#!/bin/sh
set -eux

# Environment variables.
TZ=${TZ:-UTC}

# Set timezone if not UTC
if [ ${TZ} != "UTC" ]; then
	cp /usr/share/zoneinfo/${TZ} /etc/localtime
	echo ${TZ} > /etc/timezone
fi

# First arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- memcached "$@"
fi

exec gosu memcache "$@"