# This Dockerfile is used to build the base containers used for continuous
# integration.
# The containers will have an internal installation of docker available and
# therefore needs to be started with the --privileged flag.
FROM ubuntu:16.04

# install and upgrade command packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y apt-transport-https ca-certificates build-essential git curl libsystemd-dev

# install docker
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#RUN echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" > /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-get install -y docker-engine=1.9.1-0~wily

# install docker-compose
RUN curl -s -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# tweaks
RUN echo '151.101.36.162 registry.npmjs.com' >> /etc/hosts
RUN echo '151.101.36.162 registry.npmjs.org' >> /etc/hosts

# configure the container's entrypoint
COPY files/Makefile.docker /usr/src/Makefile.docker
ENTRYPOINT ["make", "-f", "/usr/src/Makefile.docker"]
