echo "Starting processes..."

cd /etc/init.d/

./prosody restart && \
./jitsi-videobridge restart && \
./jicofo restart && \
./nginx restart