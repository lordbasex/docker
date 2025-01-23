FROM debian:bookworm-slim

# Metadata and labels
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>" \
      version="1.0" \
      description="QEMU system emulator with web interface" \
      org.opencontainers.image.source="https://github.com/lordbasex/docker/docker-qemu"

ARG VERSION_ARG="0.0"
ARG VERSION_VNC="1.5.0"

ARG DEBCONF_NOWARNINGS="yes"
ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBCONF_NONINTERACTIVE_SEEN="true"

RUN set -eu && \
    apt-get update && \
    apt-get --no-install-recommends -y install \
        tini \
        wget \
        7zip \
        p7zip-full \
        nginx \
        procps \
        seabios \
        iptables \
        iproute2 \
        apt-utils \
        dnsmasq \
        xz-utils \
        net-tools \
        qemu-utils \
        genisoimage \
        ca-certificates \
        netcat-openbsd \
        qemu-system-arm \
        qemu-system-x86 \
        qemu-efi-aarch64 && \
    # Clean up apt cache to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Setup noVNC
RUN mkdir -p /usr/share/novnc && \
    wget "https://github.com/novnc/noVNC/archive/refs/tags/v${VERSION_VNC}.tar.gz" -O /tmp/novnc.tar.gz -q --timeout=10 && \
    tar -xf /tmp/novnc.tar.gz -C /tmp/ && \
    cd "/tmp/noVNC-${VERSION_VNC}" && \
    mv app core vendor package.json *.html /usr/share/novnc && \
    sed -i "s|UI\.initSetting('path', 'websockify')|UI.initSetting('path', window.location.pathname.replace(/[^/]*$/, '').substring(1) + 'websockify')|" /usr/share/novnc/app/ui.js && \
    # Clean up temporary files
    rm -rf /tmp/*

# Configure nginx
RUN unlink /etc/nginx/sites-enabled/default && \
    sed -i 's/^worker_processes.*/worker_processes 1;/' /etc/nginx/nginx.conf

# Copy configuration files and scripts with appropriate permissions
COPY --chmod=755 ./src /run/
COPY --chmod=664 ./web/index.html /var/www/index.html
COPY --chmod=664 ./web/js/script.js /var/www/js/script.js
COPY --chmod=664 ./web/css/style.css /var/www/css/style.css
COPY --chmod=664 ./web/img/favicon.svg /var/www/img/favicon.svg
COPY --chmod=744 ./web/nginx.conf /etc/nginx/sites-enabled/web.conf

VOLUME /storage
EXPOSE 22 5900 8006

# Set default environment variables
ENV CPU_CORES="1" \
    RAM_SIZE="1G" \
    DISK_SIZE="16G" \
    DISK_FORMAT="qcow2" \
    ARCH="amd64" \
    BOOT="" \
    DEBUG="no"

# Use tini as init system
ENTRYPOINT ["/usr/bin/tini", "-s", "/run/entry.sh"]