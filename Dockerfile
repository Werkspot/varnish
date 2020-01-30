FROM ubuntu:18.04

LABEL maintainer="technology@werkspot.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update \
    && apt-get install -y curl \
    && curl -s https://packagecloud.io/install/repositories/varnishcache/varnish60lts/script.deb.sh | bash \
    && apt-get install -y varnish \ 
    make \
    pkg-config \
    varnish-dev=6.0.5-1~bionic \
    automake \
    libtool\
    libmhash-dev\
    python-docutils \
    supervisor \
    && rm -rf /var/lib/apt/lists/* 

RUN cd /tmp \
    && curl -O -L https://download.varnish-software.com/varnish-modules/varnish-modules-0.15.0.tar.gz \
    && tar zxfv varnish-modules-0.15.0.tar.gz \
    && cd /tmp/varnish-modules-0.15.0 \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/varnish*

RUN cd /tmp \
    && curl -O -L https://github.com/varnish/libvmod-digest/archive/libvmod-digest-1.0.2.tar.gz \
    && tar zxfv libvmod-digest-1.0.2.tar.gz \
    && cd /tmp/libvmod-digest-libvmod-digest-1.0.2 \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/libvmod-digest**

RUN chown nobody:nogroup -R /etc/varnish

ARG EXPORTER_VERSION=1.5.2
RUN mkdir -p /opt/prometheus_varnish_exporter \
    && cd /opt/prometheus_varnish_exporter \
    && curl -L -O https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/${EXPORTER_VERSION}/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz \
    && tar zxfv prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz \
    && ln -s /opt/prometheus_varnish_exporter/prometheus_varnish_exporter-${EXPORTER_VERSION}.linux-amd64/prometheus_varnish_exporter /usr/local/bin/

#Prometheus exporter
EXPOSE 9131

ENV LISTEN_ADDRESS "*:8080"
ENV WORKING_DIRECTORY "/tmp/varnish"

USER nobody:nogroup
CMD varnishd -f /etc/varnish/default.vcl -s malloc,100M -a $LISTEN_ADDRESS -n $WORKING_DIRECTORY -F
