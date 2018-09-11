FROM recallcode/jdk:8u172

RUN mkdir -p /opt/config-center/bin && mkdir -p /opt/config-center/conf && mkdir -p /opt/config-center/lib

COPY ./bin /opt/config-center/bin

COPY ./conf /opt/config-center/conf

COPY ./lib /opt/config-center/lib

RUN chmod +x /opt/config-center/bin/startup.sh && chmod +x /opt/config-center/bin/build.sh

ENTRYPOINT ["/opt/config-center/bin/startup.sh"]
