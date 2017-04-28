FROM 971811985820.dkr.ecr.ap-southeast-2.amazonaws.com/platform-container-nginx:latest

RUN yum install -y unzip

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