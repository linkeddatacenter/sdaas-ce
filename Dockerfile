# Copyright (C) 2019-2020 LinkedData.Center - All Rights Reserved
# Permission to copy and modify is granted under the MIT license
FROM  linkeddatacenter/sdaas-rdfstore:2.1.2

LABEL authors="enrico@linkeddata.center"

USER root
RUN apt-get update ; \
	apt-get install -y --no-install-recommends \
		curl \
		gettext \
		bats

ENV SDAAS_BIN_DIR "/opt/sdaas-bin"
ENV SDAAS_LOG_DIR /var/log/sdaas
ENV SD_UPLOAD_DIR /tmp/upload
ENV SD_SPARQL_ENDPOINT http://localhost:8080/sdaas/sparql
ENV SD_QUADSTORE kb
ENV SDAAS_SIZE micro

COPY scripts "$SDAAS_BIN_DIR"
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod -R 0755 "$SDAAS_BIN_DIR" /docker-entrypoint.sh; \
	mkdir -p /workspace "$SDAAS_LOG_DIR" "$SD_UPLOAD_DIR" ; \
	chown -R jetty.jetty /workspace /docker-entrypoint.sh "$SDAAS_LOG_DIR" "$SD_UPLOAD_DIR"

USER jetty
WORKDIR  /workspace

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [""]