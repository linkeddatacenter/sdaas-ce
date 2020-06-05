# Copyright (C) 2019-2020 LinkedData.Center - All Rights Reserved
# Permission to copy and modify is granted under the MIT license
FROM  linkeddatacenter/sdaas-rdfstore:2.0.0

LABEL authors="enrico@linkeddata.center"

USER root
RUN set -xe ; \
	apt-get update ; \
	apt-get install -y --no-install-recommends curl gettext

## To add debugging tools uncomment following liness:
#RUN echo "jetty\n$jetty" | passwd jetty
#RUN apt-get install -y sudo ; usermod -aG sudo jetty

ENV SDAAS_BIN_DIR /usr/local/bin/sdaas
COPY scripts $SDAAS_BIN_DIR
COPY tests/system/platform /workspace

RUN chmod -R 0755 $SDAAS_BIN_DIR; \
	chown -R jetty.jetty /workspace
ENV PATH="${SDAAS_BIN_DIR}:${PATH}"

USER jetty
WORKDIR  /workspace
ENV SD_REASONER_ENDPOINT http://localhost:8080/sdaas
