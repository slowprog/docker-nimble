FROM phusion/baseimage:0.11

## Install nimble and move all config files to /etc/nimble.conf
##
RUN apt-get update \
    && apt-get install -y wget gnupg2 \
    && echo "deb http://nimblestreamer.com/ubuntu bionic/" > /etc/apt/sources.list.d/nimblestreamer.list \
    && wget -q -O - http://nimblestreamer.com/gpg.key | apt-key add - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y nimble \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir /etc/nimble.conf \
    && mv /etc/nimble/* /etc/nimble.conf

## Configuration volume
##
VOLUME /etc/nimble

## Cache volume
##
VOLUME /var/cache/nimble

## WMS panel username and password
## Only required for first time registration
##
ENV WMSPANEL_USER	""
ENV WMSPANEL_PASS	""
ENV WMSPANEL_SLICES	""

## Service configuration
##
ADD files/my_init.d /etc/my_init.d
ADD files/service /etc/service
ADD files/logrotate.d /etc/logrotate.d

EXPOSE 1935 8081 8082