############################
# STEP 1 build executable binary
############################
FROM alpine AS builder

ENV GO111MODULE=on \
    GOPATH=/home/go \
    PATH=/home/go/bin:$PATH \
    GOBIN=/home/go/bin

RUN apk update && apk add --no-cache git go bash ca-certificates
RUN mkdir -p /home/go/src /home/go/bin /home/go/src/amigo && chmod -R 777 /home/go /home/go/src/amigo && cp -fr /usr/bin/go /home/go/bin/
WORKDIR /home/go/src/amigo
COPY ./amigo.go .
COPY ./go.mod .
RUN go get -v
RUN go build -o /go/bin/amigo.go

############################
# STEP 2 build a small image
############################
FROM alpine:latest

COPY --from=builder /go/bin/amigo.go /go/bin/amigo.go

ENV AMI_HOST=localhost \
  AMI_PORT=5038 \
  AMI_USERNAME=admin \
  AMI_PASSWORD=123456

ENTRYPOINT ["/go/bin/amigo.go"]
