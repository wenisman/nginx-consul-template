#! /usr/local/bin/dumb-init /bin/sh

consul-template -consul-addr="10.134.16.133:8500" -template "/etc/nginx/conf.d/default.conf.ctpl:/etc/nginx/conf.d/default.conf" -once &
nginx -c "/etc/nginx/nginx.conf" -g "daemon off;" &
#consul agent -retry-join-ec2-tag-key="Name" -retry-join-ec2-region="ap-southeast-2" -retry-join-ec2-tag-value="dev-service-discovery" -config-dir="/consul/config" -data-dir="/consul/data" &
consul-template -consul-addr="10.134.16.133:8500" -template "/etc/nginx/conf.d/default.conf.ctpl:/etc/nginx/conf.d/default.conf:/bin/bash -c 'nginx -s reload || true'"
