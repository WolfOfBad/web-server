#!/bin/bash

NGINX_CONF="/etc/nginx/conf.d/default.conf"

APACHE_HOST="${APACHE_HOST:-apache:80}"

sed -i "s|proxy_pass http://apache:80;|proxy_pass http://$APACHE_HOST;|g" "$NGINX_CONF"
