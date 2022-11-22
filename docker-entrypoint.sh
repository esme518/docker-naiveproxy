#!/bin/sh
set -e

if [ ! -f passwd ] && [ -z "$PASSWORD" ]; then
	cat /dev/urandom | tr -dc a-zA-Z0-9 | head -c32 > passwd
elif [ ! -f passwd ] && [ -n "$PASSWORD" ]; then
	echo $PASSWORD > passwd
fi

# Set Caddyfile
if [ ! -f /etc/caddy/Caddyfile ]; then
	PASSWORD=$(cat passwd)
	cp /etc/caddy/Caddyfile.init /etc/caddy/Caddyfile
	sed -i "s/ADDRESS/$ADDRESS/g" /etc/caddy/Caddyfile
	sed -i "s/EMAIL/$EMAIL/g" /etc/caddy/Caddyfile
	sed -i "s/USER/$USER/g" /etc/caddy/Caddyfile
	sed -i "s/PASSWORD/$PASSWORD/g" /etc/caddy/Caddyfile
	echo "NaïveProxy Initialized"
	echo \""proxy"\": \""https://$USER:$PASSWORD@$ADDRESS"\"
fi

exec "$@"
