# Copyright (C) 2019 LinkedData.Center - All Rights Reserved
# Permission to copy and modify is granted under the MIT license
FROM  lyrasis/blazegraph:2.1.5

LABEL authors="enrico@linkeddata.center"

USER root

ENV SD_REASONER_ENDPOINT http://localhost:8080/sdaas
ENV SDAAS_BIN_DIR /usr/local/bin/sdaas
ENV PATH="${SDAAS_BIN_DIR}:${PATH}"

COPY tests/system/platform /workspace
COPY *-web.xml /
COPY sdaas-* /
COPY alpinelinux_provisioning.sh /
COPY scripts $SDAAS_BIN_DIR
RUN chmod -R 0755 $SDAAS_BIN_DIR; /alpinelinux_provisioning.sh

RUN apk --no-cache add \
	unzip \
	sudo

# unpack and rename the blazegraph webapp
RUN unzip ${JETTY_WEBAPPS}/bigdata.war -d ${JETTY_WEBAPPS}/sdaas; \
	rm -f ${JETTY_WEBAPPS}/bigdata.war

WORKDIR  /workspace

CMD /sdaas-start --foreground