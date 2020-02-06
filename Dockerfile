FROM ubuntu:bionic as build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update 
RUN apt-get install -y \
  wget \
  ca-certificates

# download the pivnet binary
RUN wget -O /usr/local/bin/pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v1.0.0/pivnet-linux-amd64-1.0.0 && \
    chmod +x /usr/local/bin/pivnet

COPY scripts* /scripts

FROM ubuntu:bionic
COPY --from=build /usr/local/bin/pivnet /usr/local/bin/pivnet
COPY --from=build /scripts/* /opt/pivnet/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY tion.yml /opt/tion/tion.yml

# define channels for input and output
LABEL com.tion.channels.in="in"
LABEL com.tion.channels.out="out"
