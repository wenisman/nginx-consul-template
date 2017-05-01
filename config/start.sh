#! /bin/sh

consul agent -datacenter="$CONSUL_NAME" -encrypt="3a6nE3qvOSwaPVcg73nxLQ==" -retry-join-ec2-tag-key="Name" -retry-join-ec2-region="ap-southeast-2" -retry-join-ec2-tag-value="$CONSUL_NAME" -config-dir="/consul/config" -data-dir="/consul/data" &
consul-template -consul-addr="127.0.0.1:8500" -template "/etc/nginx/conf.d/default.conf.ctpl:/etc/nginx/conf.d/default.conf" -once &
nginx -c "/etc/nginx/nginx.conf" -g "daemon off;" &
consul-template -consul-addr="127.0.0.1:8500" -template "/etc/nginx/conf.d/default.conf.ctpl:/etc/nginx/conf.d/default.conf:/bin/bash -c 'nginx -s reload || true'"