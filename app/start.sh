#!/bin/sh
set -eux

# Environment variables.
ENV=${ENV:-development}
TZ=${TZ:-UTC}

# Set timezone if not UTC
if [ $TZ != "UTC" ]; then
	cp /usr/share/zoneinfo/${TZ} /etc/localtime
	echo ${TZ} > /etc/timezone

	if [ -f ${PHP_INI_DIR}/php.ini-${ENV} ]; then
		cp ${PHP_INI_DIR}/php.ini-${ENV} ${PHP_INI_DIR}/php.ini
		sed -i -e  "s#;date.timezone =#date.timezone = ${TZ}#" ${PHP_INI_DIR}/php.ini
	else
		{ \
			echo "[Date]"; \
			echo "date.timezone = ${TZ}"; \
		} | tee ${PHP_INI_DIR}/conf.d/date.ini
	fi
fi

# First arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"