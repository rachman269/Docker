#!/bin/sh
set -eux

# Environment variables.
TZ=${TZ:-UTC}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

# Set timezone if not UTC
if [ ${TZ} != "UTC" ]; then
	cp /usr/share/zoneinfo/${TZ} /etc/localtime
	echo ${TZ} > /etc/timezone
fi

# Make sure mysqld directory is exists.
if [ -d "/run/mysqld" ]; then
    echo '[i] mysqld directory already present, skipping creation'
    chown -R mysql:mysql /run/mysqld
else
    echo '[i] mysqld directory not found, creating...'
	mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

# Make sure mysql directory is exists.
if [ -d /var/lib/mysql/mysql ]; then
    echo '[i] mysql directory already present, skipping creation'
    chown -R mysql:mysql /var/lib/mysql
else
    echo '[i] mysql directory not found, creating initial DBs'
    chown -R mysql:mysql /var/lib/mysql

    echo '[i] Initializing database'
    mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

    tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

    echo "[i] Run tempfile: $tfile"
    /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
    rm -f $tfile
fi

# If command starts with an option.
if [ "${1#-}" != "$1" ]; then
	set -- mysqld "$@"
fi

exec gosu mysql "$@"