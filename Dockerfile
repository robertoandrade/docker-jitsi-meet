FROM debian:latest
MAINTAINER Roberto Andrade <roberto@cloud.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LOG=/var/log/jitsi/jvb.log

# Prerequisites
RUN echo 'deb http://http.debian.net/debian jessie-backports main' >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get install -y wget dnsutils vim telnet prosody openjdk-8-jdk && \
	rm /etc/prosody/conf.*/localhost.cfg.lua && \
	update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# Jitsi Meet and dependencies
RUN echo 'deb http://download.jitsi.org/nightly/deb unstable/' >> /etc/apt/sources.list && \
	wget -qO - https://download.jitsi.org/nightly/deb/unstable/archive.key | apt-key add - && \
	apt-get update && \
	apt-get -y install jitsi-meet && \
	apt-get clean

# Customizing installation

ENV NGINX_CONF=/etc/nginx/sites-enabled/*.conf
ENV AUTHBIND_CONF=/etc/authbind/byport/443
ENV SIP_CONF_DIR=/usr/share/jitsi-videobridge/.sip-communicator

RUN touch $LOG && \
	chown jvb:jitsi $LOG && \
	chmod +xr -R /var/log/jitsi && \
	mkdir /etc/ssl/nginx && \
	cp /var/lib/prosody/localhost.* /etc/ssl/nginx && \
	cat $NGINX_CONF \
		| tr '\n' '\r' \
		| sed -e 's/server_name localhost;/server_name ~.*$;/' \
		| sed -e 's/listen 443 ssl;/listen 4443 ssl;/' \
		| sed -e 's/\/var\/lib\/prosody/\/etc\/ssl\/nginx/g' \
		| sed -e 's/proxy_set_header Host $http_host;/proxy_set_header Host localhost;/' \
		| tr '\r' '\n' \
		> /tmp/nginx.conf && \
	cp /tmp/nginx.conf $NGINX_CONF && \
	sed "s/\/\/localhost\//\/\/'\+document.location.host\+'\//g" -i /etc/jitsi/meet/*.js && \
	sed 's/JVB_OPTS=""/JVB_OPTS="--apis=rest,xmpp"\nAUTHBIND=yes/' -i /etc/jitsi/videobridge/config && \
	touch $AUTHBIND_CONF && \
	chown jvb:jitsi $AUTHBIND_CONF && \
	chmod u+x $AUTHBIND_CONF

EXPOSE 80 443

RUN mkdir -p /app/src && \
	mkdir -p $SIP_CONF_DIR/log && \
	chown -R jvb:jitsi $SIP_CONF_DIR/

COPY sip-communicator.properties $SIP_CONF_DIR/
COPY run.sh jitsi-meet.sh /app/src/

CMD /app/src/run.sh