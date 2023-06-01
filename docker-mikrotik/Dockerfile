FROM --platform=$BUILDPLATFORM alpine AS build

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

# Configuración de variables de entorno
ENV ROUTEROS_URL=https://download.mikrotik.com/routeros/7.6/chr-7.6.vdi.zip
ENV ROUTEROS_IMAGE=chr-7.6.vdi
ENV ROUTEROS_VERSION=7.6
ENV VNCPASSWORD=false
ENV KEYBOARD=en-us

# Instalación de dependencias
RUN set -xe \
    && apk add --no-cache --update \
        wget \
        netcat-openbsd \
        qemu-x86_64 \
        qemu-system-x86_64 \
        busybox-extras \
        iproute2 \
        iputils \
        bridge-utils \
        iptables \
        jq \
        bash \
        python3 \
        curl

# Descarga y descompresión del archivo de imagen de RouterOS
RUN mkdir /routeros && wget ${ROUTEROS_URL} -O /routeros/${ROUTEROS_IMAGE}.zip \
    && unzip /routeros/${ROUTEROS_IMAGE}.zip -d /routeros \
    && rm -fr /routeros/${ROUTEROS_IMAGE}.zip

# Configuración de directorio de trabajo
WORKDIR /routeros

# Copia de archivos y directorios
COPY bin /routeros/bin

# Exposición de puertos
EXPOSE 1723
EXPOSE 1701
EXPOSE 1194
EXPOSE 21
EXPOSE 22
EXPOSE 23
EXPOSE 443
EXPOSE 80
EXPOSE 8291
EXPOSE 8728
EXPOSE 8729

# Dar permisos de ejecución a los archivos necesarios
RUN chmod +x /routeros/bin/entrypoint.sh
RUN chmod +x /routeros/bin/generate-dhcpd-conf.py
RUN chmod +x /routeros/bin/qemu-ifup
RUN chmod +x /routeros/bin/qemu-ifdown

# Punto de entrada
ENTRYPOINT ["/routeros/bin/entrypoint.sh"]
