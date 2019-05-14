FROM ubuntu:16.04

LABEL maintainer="technology@werkspot.com"
 
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update \
    && apt-get install -y varnish \
    && rm -rf /var/lib/apt/lists/*

ENV LISTEN_ADDRESS "*:8080" \
ENV WORKING_DIRECTORY "/tmp/varnish"

USER nobody:nogroup

CMD varnishd -f /etc/varnish/default.vcl -s malloc,100M -a $LISTEN_ADDRESS -n $WORKING_DIRECTORY -F
