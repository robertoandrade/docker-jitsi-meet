# docker-jitsi-meet

Docker container for [jitsi-meet][3]

> Jitsi Meet is an open-source (MIT) WebRTC JavaScript application that uses Jitsi Videobridge to provide high quality, scalable video conferences."  "Jitsi Meet allows for very efficient collaboration. It allows users to stream their desktop or only some windows. It also supports shared document editing with Etherpad and remote presentations with Prezi.


## Install dependencies

  - [Docker][2]

To install docker in Ubuntu 14.04 use the commands:

    $ sudo apt-get update
    $ sudo apt-get install docker.io

 To install docker in other operating systems check [docker online documentation][4]

## Usage (if checking out this repository)

To run container use the command below (first time):

    $ ./docker-build && ./docker-run
	# Will prompt for a few configuration parameters

or (subsequent times):

    $ docker start jitsi-meet

## Usage (downloading pre-built image from Docker Hub)

	$ docker run -it --name jitsi-meet -p 80:80 -p 443:443 -p 5347:5347 -p 10000-10010:10000-10010 robertoandrade/jitsi-meet

## Accessing the web app:

After that open up the following address :

  - **http://$DOCKER_HOST/**


## More Info

About jitsi-meet: [www.jitsi.org][1]

To help improve this container [docker-jitsi-meet][5]

Example of this [docker-jitsi-meet][6]

[1]:https://jitsi.org/
[2]:https://www.docker.com
[3]:https://jitsi.org/
[4]:http://docs.docker.com
[5]:https://github.com/QuantumObject/docker-jitsi-meet