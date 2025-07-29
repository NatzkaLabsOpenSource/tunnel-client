FROM ubuntu:22.04 AS builder

WORKDIR /tmp
RUN apt-get -y update && \
    apt-get -y install curl && \
    rm -rf /var/lib/apt/lists/*

ARG VERSION=v0.1.0_30a12d59fc
ARG TARGETARCH
RUN curl -L "https://cdn.natzkalabs.com/downloads/tunnel-client/tunnel-client-linux-$TARGETARCH-$VERSION.tar.gz" -o tunnel-client.tar.gz && \
    tar xf tunnel-client.tar.gz

FROM ubuntu:22.04

RUN apt-get -y update && \
    apt-get -y install ca-certificates tzdata && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -u 1000 -ms /bin/bash tunnel-client

COPY --from=builder /tmp/tunnel-client /usr/local/bin/tunnel-client
COPY --chmod=555 distribution/docker/entrypoint.sh /entrypoint.sh

USER 1000

WORKDIR /home/tunnel-client
ENTRYPOINT ["/entrypoint.sh"]
