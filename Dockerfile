# Copyright (C) 2019-2020 LinkedData.Center - All Rights Reserved
# Permission to copy and modify is granted under the MIT license
FROM alpine/helm as helm
FROM mikefarah/yq as yq
FROM  linkeddatacenter/sdaas-rdfstore:2.1.5

LABEL authors="enrico@linkeddata.center"

USER root
COPY --from=helm /usr/bin/helm /usr/bin/helm
COPY --from=yq /usr/bin/yq /usr/bin/yq

ARG SHACLVER=1.3.2
ARG SHACLROOT=/opt/shacl-${SHACLVER}/bin

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		gettext \
		bats \
		git \
		unzip \
		jq \
		csvtool && \
    curl --output /tmp/shacl.zip  https://repo1.maven.org/maven2/org/topbraid/shacl/${SHACLVER}/shacl-${SHACLVER}-bin.zip && \
    unzip /tmp/shacl.zip -d /opt && \
    chmod +x ${SHACLROOT}/*



###### Variables affecting the image building
ENV SDAAS_BIN_DIR=/opt/sdaas
ENV SDAAS_WORKSPACE=/workspace
ENV SDAAS_LOG_DIR="$SDAAS_WORKSPACE"


###### Runtime variables
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