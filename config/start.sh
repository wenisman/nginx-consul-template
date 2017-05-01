#! /usr/local/bin/dumb-init /bin/sh

consul-template -consul-addr="$CONSUL_URI" -template "/etc/nginx/conf.d/default.conf.ctpl:/etc/nginx/conf.d/default.conf" -once &
nginx -c "/etc/nginx/nginx.conf" -g "daemon off;" &
consul-template -consul-addr="$CONSUL_URI" -template "/etc/nginx/conf.d/default.conf.ctpl:/etc/nginx/conf.d/default.conf:/bin/bash -c 'nginx -s reload || true'"
