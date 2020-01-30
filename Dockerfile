FROM varnish:6.0.5

LABEL maintainer="technology@werkspot.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update \
    && apt-get install -y \
    make \
    automake \
    autotools-dev \
    libedit-dev \
    libjemalloc-dev \
    libncurses-dev \
    libpcre3-dev \
    libtool \
    pkg-config \
    libvarnishapi1 \
    libvarnishapi-dev \
    curl \
    supervisor \
    && rm -rf /var/lib/apt/lists/*
RUN chown nobody:nogroup -R /etc/varnish
RUN cd /tmp \
    && curl -O -L https://download.varnish-software.com/varnish-modules/varnish-modules-0.15.0.tar.gz \
    && tar zxfv varnish-modules-0.15.0.tar.gz \
    && cd /tmp/varnish-modules-0.15.0 \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/varnish*

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
