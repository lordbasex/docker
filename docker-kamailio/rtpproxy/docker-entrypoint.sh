#!/bin/sh
: ${CLOUD=""} # One of aws, azure, do, gcp, or empty
if [ "$CLOUD" != "" ]; then
   PROVIDER="-provider ${CLOUD}"
fi

: ${MIN_PORT="10000"}
: ${MAX_PORT="20000"}
: ${SOCKET_ADDR="udp:127.0.0.1:7722"}
: ${PRIVATE_IPV4="$(netdiscover -field privatev4 ${PROVIDER})"}
: ${PUBLIC_IPV4="$(netdiscover -field publicv4 ${PROVIDER})"}

: ${RTPPROXY_ARGS:="-f -A ${PUBLIC_IPV4} -F -l ${PRIVATE_IPV4} -m ${MIN_PORT} -M ${MAX_PORT} -s ${SOCKET_ADDR} -d INFO"}

# If we were given arguments, run them instead
if [ $# -gt 0 ]; then
   exec "$@"
fi

# Run rtpproxy
exec /usr/bin/rtpproxy ${RTPPROXY_ARGS}
