FROM alpine:3.9

LABEL maintainer="technology@werkspot.com"
 
RUN apk add --no-cache varnish

ENV LISTEN_ADDRESS ":8080" \
    WORKING_DIRECTORY="/tmp/varnish"

USER nobody:nogroup

CMD varnishd -f /etc/varnish/default.vcl -s malloc,100M -a $LISTEN_ADDRESS -n $WORKING_DIRECTORY -F
