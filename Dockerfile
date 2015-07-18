FROM heroku/cedar:14
MAINTAINER Roberto Andrade <roberto@cloud.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LOG=/var/log/jitsi/jvb.log

# Prerequisites
RUN apt-get update && \
	apt-get install -y wget dnsutils vim telnet prosody && \
	rm /etc/prosody/conf.*/localhost.cfg.lua

# Jitsi Meet and dependencies
RUN echo 'deb http://download.jitsi.org/nightly/deb unstable/' >> /etc/apt/sources.list && \
	wget -qO - https://download.jitsi.org/nightly/deb/unstable/archive.key | apt-key add - && \
	apt-get update && \
	apt-get -y install jitsi-meet && \
	apt-get clean

# Customizing installation

ENV NGINX_CONF=/etc/nginx/sites-enabled/*.conf

RUN touch $LOG && \
	chown jvb:jitsi $LOG && \
	chmod +xr -R /var/log/jitsi && \
	cat $NGINX_CONF \
		| tr '\n' '\r' \
		| sed -e 's/listen 80;/listen 3000;/' \
		| sed -e 's/return 301.*root/root/' \
		| sed -e 's/proxy_set_header Host $http_host;/proxy_set_header Host localhost;/' \
		| tr '\r' '\n' \
		> /tmp/nginx.conf && \
	cp /tmp/nginx.conf $NGINX_CONF && \
	sed "s/\/\/localhost\//\/\/'\+document.location.host\+'\//g" -i /etc/jitsi/meet/*.js

EXPOSE 3000

# Heroku settings

RUN useradd -d /app -m app
USER app
WORKDIR /app

ENV HOME /app
ENV PORT 3000

RUN mkdir -p /app/heroku
RUN mkdir -p /app/src
RUN mkdir -p /app/.profile.d

WORKDIR /app/src

# App runtime
COPY run.sh jitsi-meet.sh /app/src/

USER root

CMD /app/src/run.sh