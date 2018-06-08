#!/bin/sh
echo -en "$CONFIG" > /etc/keepalived/keepalived.conf

## start
rm -f /var/run/keepalived.pid
exec keepalived "$@" \
	-l -n -D -f /etc/keepalived/keepalived.conf
