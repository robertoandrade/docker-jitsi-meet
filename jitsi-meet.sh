if [ ! -f /etc/ssl/nginx/localhost.jks ]; then
	echo "Importing certificate..."

	cd /etc/ssl/nginx/
	openssl pkcs12 -export -in localhost.crt -inkey localhost.key -password pass:changeit > localhost.p12
	keytool -importkeystore -srckeystore localhost.p12 -destkeystore localhost.jks -srcstoretype pkcs12 -srcstorepass changeit -deststorepass changeit
fi

echo "Starting processes..."

cd /etc/init.d/

./prosody restart && \
./jitsi-videobridge restart && \
./jicofo restart && \
./nginx restart