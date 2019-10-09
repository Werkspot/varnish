FROM ubuntu:16.04

LABEL maintainer="technology@werkspot.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update \
    && apt-get install -y varnish \
    && rm -rf /var/lib/apt/lists/*
RUN chown nobody:nogroup -R /etc/varnish

ARG EXPORTER_VERSION=1.5.1
RUN mkdir -p /opt/prometheus_varnish_exporter \
    && cd /opt/prometheus_varnish_exporter \
    && apt-get -qq update \
        && apt-get install -y curl supervisor \
        && rm -rf /var/lib/apt/lists/* \
    && curl -L -O https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/${EXPORTER_VERSION}/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz \
    && tar zxfv prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz \
    && ln -s /opt/prometheus_varnish_exporter/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64/prometheus_varnish_exporter /usr/local/bin/

#Prometheus exporter
EXPOSE 9131

ENV LISTEN_ADDRESS "*:8080"
ENV WORKING_DIRECTORY "/tmp/varnish"

USER nobody:nogroup
CMD varnishd -f /etc/varnish/default.vcl -s malloc,100M -a $LISTEN_ADDRESS -n $WORKING_DIRECTORY -F
