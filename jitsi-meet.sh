echo "Importing certificate..."

cd /etc/jitsi/videobridge
keytool -import -trustcacerts -alias localhost -file /etc/ssl/nginx/localhost.crt -keystore localhost.jks -storepass changeit -noprompt

echo "Starting processes..."

cd /etc/init.d/

./prosody restart && \
./jitsi-videobridge restart && \
./jicofo restart && \
./nginx restart