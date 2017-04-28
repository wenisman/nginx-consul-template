FROM alpine:3.5

# install nginx, unzip, dumb-init
RUN apk add --update nginx && \
    apk add --update unzip && \
    apk add --update dumb-init && \
    rm -rf /var/cache/apk/*

# RUN adduser -D -u 1000 -g 'nginx' nginx

RUN chown -R nginx:nginx /var/lib/nginx

ENV CONSUL_VERSION 0.8.0
ENV CONSUL_TEMPLATE_VERSION 0.18.2

#install consul
ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip /tmp/
RUN unzip -d /usr/local/bin /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip

# install consul-template
ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /tmp/
RUN unzip -d /usr/local/bin /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

# make the consul directories
RUN mkdir -p /consul/data && \
    mkdir -p /consul/config/agent && \
    mkdir -p /etc/nginx/conf.d

COPY config/conf.d /etc/nginx/conf.d
COPY config/consul/config.json /consul/config/agent/config.json
COPY config/start.sh /start.sh
COPY config/nginx.conf /etc/nginx/nginx.conf

RUN [ "chmod", "+x", "/start.sh" ]

EXPOSE 80 8300 8301 8301/UDP 8302 8302/UDP 8500 8600

CMD [ "/start.sh" ]
