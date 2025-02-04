FROM ubuntu:22.04

RUN apt update && \
  apt -y install wget openssh-server curl sudo iproute2

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit

RUN curl -fsSL https://get.docker.com -o /usr/local/bin/install-docker.sh && \
  chmod +x /usr/local/bin/install-docker.sh

RUN sh /usr/local/bin/install-docker.sh

COPY open-webui.tar.gz /
RUN mkdir -p /mnt/data/docker/images && \
    mv /open-webui.tar.gz /mnt/data/docker/images/

COPY ./scripts/ /scripts/
COPY ./zinit/ /etc/zinit/
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/sbin/zinit", "init"]