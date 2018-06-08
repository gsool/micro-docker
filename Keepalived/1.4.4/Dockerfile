FROM alpine:edge

ENV TZ=Asia/Shanghai

RUN set -x && apk add --no-cache tzdata \
	&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
	&& apk add --no-cache keepalived

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
