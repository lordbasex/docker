FROM alpine:latest

LABEL maintainer="Federico Pereira <lord.basex@gmail.com>"
LABEL github="https://github.com/lordbasex/docker/tree/master/docker-rclone"

ARG RCLONE_VERSION=current
ARG ARCH=amd64

RUN apk --no-cache add \
  ca-certificates \
  curl \
  fuse \
  unzip

RUN cd /tmp && \
  wget https://downloads.rclone.org/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip && \
  unzip /tmp/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip && \
  mv -v /tmp/rclone-*-linux-${ARCH}/rclone /usr/bin && \
  rm -r /tmp/rclone* && \
  apk del \
  curl \
  unzip

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/media"]

EXPOSE 5572/tcp

ENTRYPOINT ["sh", "-c", "/usr/bin/rclone rcd --rc-web-gui --config=/config/rclone.conf --rc-user=${RCUSER} --rc-pass=${RCPASS} --rc-addr=0.0.0.0:5572 --rc-serve"]
