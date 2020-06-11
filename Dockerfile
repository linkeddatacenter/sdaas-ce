# Copyright (C) 2019-2020 LinkedData.Center - All Rights Reserved
# Permission to copy and modify is granted under the MIT license
FROM  linkeddatacenter/sdaas-rdfstore:2.1.3

LABEL authors="enrico@linkeddata.center"

USER root
RUN apt-get update ; \
	apt-get install -y --no-install-recommends \
		curl \
		gettext \
		bats

###### Variables affecting the image building
ENV SDAAS_BIN_DIR=/opt/sdaas
ENV SDAAS_WORKSPACE=/workspace
ENV SDAAS_LOG_DIR="$SDAAS_WORKSPACE"


###### Runtime variables
ENV SD_CACHE="$SDAAS_LOG_DIR/.cache"
ENV SD_UPLOAD_DIR /var/spool/sdaas
ENV SD_SPARQL_ENDPOINT http://localhost:8080/sdaas/sparql
ENV SD_QUADSTORE kb

COPY scripts "$SDAAS_BIN_DIR"
COPY sdaas-entrypoint.sh /sdaas-entrypoint.sh

RUN mkdir -p "${SDAAS_BIN_DIR}" "${SDAAS_LOG_DIR}" "${SD_UPLOAD_DIR}" "${SDAAS_WORKSPACE}" ; \
	chmod -R 0755 "$SDAAS_BIN_DIR" /sdaas-entrypoint.sh; \
	chown -R jetty.jetty "${SDAAS_WORKSPACE}" "$SDAAS_LOG_DIR" "$SD_UPLOAD_DIR"


USER jetty

WORKDIR "${SDAAS_WORKSPACE}"
ENTRYPOINT ["/sdaas-entrypoint.sh"]
CMD [""]