FROM alpine:edge

ENV TZ=Asia/Shanghai

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
	&& apk add --no-cache tzdata \
	&& ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
	&& apk add --no-cache s-nail && apk add --no-cache keepalived && apk add --no-cache bash \
	&& ln -sf /bin/bash /bin/sh

ENTRYPOINT ["keepalived", "-P", "-D", "-l", "-n"]
