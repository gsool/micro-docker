FROM recallcode/jdk:8u172

RUN mkdir -p /opt/registry-center

COPY ./bin /opt/registry-center

COPY ./conf /opt/registry-center

COPY ./lib /opt/registry-center

ENTRYPOINT ["/opt/registry-center/bin/startup.sh"]
