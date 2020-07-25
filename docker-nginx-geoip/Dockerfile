FROM nginx:stable-alpine

# Download and unpack Geoip database in legacy format from https://www.miyuru.lk/geoiplegacy

RUN apk add --no-cache libmaxminddb nginx-mod-http-geoip 

RUN cd /var/lib; \
    mkdir -p nginx; \
    wget -q -O- https://dl.miyuru.lk/geoip/maxmind/country/maxmind.dat.gz | gunzip -c > nginx/maxmind-country.dat; \
    wget -q -O- https://dl.miyuru.lk/geoip/maxmind/city/maxmind.dat.gz | gunzip -c > nginx/maxmind-city.dat; \
    chown -R nginx. nginx

ADD nginx.conf /etc/nginx