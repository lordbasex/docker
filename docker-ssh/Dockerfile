FROM alpine:3.18
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

RUN apk add --update --no-cache  openssh tzdata bash

RUN sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config \
	&& ssh-keygen -t dsa -P "" -f /etc/ssh/ssh_host_dsa_key \
	&& ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key \
	&& ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key \
	&& ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key \
	&& echo "root:123456" | chpasswd \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm /var/cache/apk/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
