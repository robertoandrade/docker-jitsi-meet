export NGINX_CONF=`ls /etc/nginx/sites-enabled/*.conf`

echo "Configuring port $PORT on $NGINX_CONF"

cat $NGINX_CONF \
		| tr '\n' '\r' \
		| sed -e "s/listen 3000;/listen $PORT;/" \
		| tr '\r' '\n' \
		> /tmp/nginx.conf && \
	cp /tmp/nginx.conf $NGINX_CONF

echo "Starting processes..."

ls -la /app/src

cd /etc/init.d/

./prosody restart && \
./jitsi-videobridge restart && \
./jicofo restart && \
./nginx restart