unset DEBIAN_FRONTEND

export LOG=/var/log/jitsi/jvb.log

if [ ! -f "$LOG" ]; then
	
	sed 's/#\ create\(.*\)/echo\ create\1 $JICOFO_AUTH_USER $JICOFO_AUTH_DOMAIN $JICOFO_AUTH_PASSWORD/' -i /var/lib/dpkg/info/jitsi-meet-prosody.postinst

	dpkg-reconfigure jitsi-videobridge
	rm /etc/jitsi/jicofo/config && dpkg-reconfigure jicofo
	/var/lib/dpkg/info/jitsi-meet-prosody.postinst configure
	dpkg-reconfigure jitsi-meet

	touch $LOG && \
	chown jvb:jitsi $LOG
fi

cd /etc/init.d/

./prosody restart && \
./jitsi-videobridge restart && \
./jicofo restart && \
./nginx restart

tail -f $LOG