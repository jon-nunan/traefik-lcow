FROM alpine:3.6
RUN apk --no-cache add ca-certificates
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) arch='arm' ;; \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac; \
	apk add --no-cache --virtual .fetch-deps libressl; \
	wget -O /usr/local/bin/traefik "https://github.com/containous/traefik/releases/download/v1.6.3/traefik_linux-$arch"; \
	apk del .fetch-deps; \
	chmod +x /usr/local/bin/traefik
	apk update && apk add ca-certificates && update-ca-certificates && apk add openssl
	wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
	tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz
COPY entrypoint.sh /
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]
