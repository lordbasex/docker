Automated builds available at https://hub.docker.com/r/mbarthelemy/nginx-geoip


 - Based on the `library/nginx:stable-alpine` image.

 - Adds the official `ngx_http_geoip_module`.

 - Embeds the latest Maxmind GeoIP DB converted to the old format suitable for `ngx_http_geoip_module`, from the excellent https://miyuru.lk/geoiplegacy (note: currently only the Country and City databases are included).

 - `/etc/nginx/nginx.conf` is modified to load the `ngx_http_geoip_module` module.

 - Ready to use, refer to http://nginx.org/en/docs/http/ngx_http_geoip_module.html.


_This product includes GeoLite2 data created by MaxMind, available from https://www.maxmind.com._


https://www.youtube.com/watch?v=ZpEfjsJamcU
