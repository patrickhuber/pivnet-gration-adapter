FROM ubuntu:bionic as build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update 
RUN apt-get install wget -y

# download the pivnet binary
RUN wget -O /usr/local/bin/pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v1.0.0/pivnet-linux-amd64-1.0.0 && \
    chmod +x /usr/local/bin/pivnet

COPY scripts* /scripts

FROM ubuntu:bionic
COPY --from=build /usr/local/bin/pivnet /usr/local/bin/pivnet
COPY --from=build /scripts/* /opt/pivnet/
COPY certificates/* /usr/local/share/ca-certificates/
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates && \
    chmod 644 /usr/local/share/ca-certificates/*.pem && \
    update-ca-certificates && \
    apt-get remove ca-certificates && \
    apt-get purge -y && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /tmp/* /var/tmp* && \
    rm -rf /var/lib/apt/lists/*
