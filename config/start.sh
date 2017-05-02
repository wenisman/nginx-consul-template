#! /bin/sh

consul agent -datacenter="$CONSUL_NAME" -node=-node="ip-$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 | sed s/\\./\-/g)" -encrypt="3a6nE3qvOSwaPVcg73nxLQ==" -retry-join-ec2-tag-key="Name" -retry-join-ec2-region="ap-southeast-2" -retry-join-ec2-tag-value="$CONSUL_NAME" -config-dir="/consul/config/agent" -data-dir="/consul/data" &
consul-template -consul-addr="127.0.0.1:8500" -template "/etc/nginx/conf.d/default.conf.ctpl:/etc/nginx/conf.d/default.conf:/bin/bash -c 'nginx -s reload || true'" &
nginx -c "/etc/nginx/nginx.conf" -g "daemon off;"
