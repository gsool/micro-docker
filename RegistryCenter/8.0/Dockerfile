FROM recallcode/jdk:8u172

RUN mkdir -p /opt/registry-center/bin && mkdir -p /opt/registry-center/conf && mkdir -p /opt/registry-center/lib

COPY ./bin /opt/registry-center/bin

COPY ./conf /opt/registry-center/conf

COPY ./lib /opt/registry-center/lib

RUN chmod +x /opt/registry-center/bin/startup.sh

ENTRYPOINT ["/opt/registry-center/bin/startup.sh"]
