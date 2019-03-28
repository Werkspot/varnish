FROM        ubuntu:16.04
MAINTAINER  Frank Lemanschik
 
ENV DEBIAN_FRONTEND noninteractive

# Update apt sources
#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

# Update the package repository
RUN apt-get -qq update

# Install base system
RUN apt-get install -y varnish

CMD ["varnishd", "-f", "/etc/varnish/default.vcl", "-s", "malloc,100M", "-a", "0.0.0.0:80", "-F"]
