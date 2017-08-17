# This Dockerfile is used to build the base containers used for continuous
# integration.
FROM ubuntu:16.04

# install dependencies
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates build-essential git curl software-properties-common libsystemd-dev && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    apt-get update && \
    apt-get install -y docker-ce && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# configure the container's entrypoint
COPY files/Makefile.docker /usr/src/Makefile.docker
ENTRYPOINT ["make", "-f", "/usr/src/Makefile.docker"]
