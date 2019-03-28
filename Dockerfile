FROM ubuntu:16.04

LABEL maintainer="technology@werkspot.com"
 
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update \
    && apt-get install -y varnish

ENV LISTEN_ADDRESS "*:80"

CMD varnishd -f /etc/varnish/default.vcl -s malloc,100M -a $LISTEN_ADDRESS -F
