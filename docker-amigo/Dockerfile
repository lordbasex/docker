############################
# STEP 1 build executable binary
############################
FROM alpine AS builder

RUN apk update && apk add --no-cache git go

WORKDIR /usr/src/myapp

COPY ./amigo.go .

RUN go get github.com/ivahaev/amigo

RUN go build -o /go/bin/amigo

############################
# STEP 2 build a small image
############################
FROM alpine:latest  

COPY --from=builder /go/bin/amigo /go/bin/amigo
ENV AMI_HOST=localhost \
  AMI_PORT=5038 \
  AMI_USERNAME=admin \
  AMI_PASSWORD=123456

ENTRYPOINT ["/go/bin/amigo"]
