############################
# STEP 1 build executable binary
############################
FROM alpine:3.17 AS builder

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV GO111MODULE=on \
    GOPATH=/home/go \
    PATH=/home/go/bin:$PATH \
    GOBIN=/home/go/bin

WORKDIR /root

RUN apk update && apk add --no-cache git go bash ca-certificates \
	&& git clone https://github.com/CyCoreSystems/netdiscover.git 

WORKDIR /root/netdiscover

RUN go build -o netdiscover main.go

RUN ./netdiscover


############################
# STEP 2 build a small image
############################
FROM alpine:3.17

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

COPY --from=builder /root/netdiscover/netdiscover /usr/bin/netdiscover

RUN apk update
RUN apk add --no-cache rtpproxy

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

