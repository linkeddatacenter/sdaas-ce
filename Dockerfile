# Copyright (C) 2023 LinkedData.Center - All Rights Reserved
FROM ubuntu:22.04

LABEL authors="enrico@linkeddata.center"

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		curl \
		ca-certificates \
		raptor2-utils \
		bats \
		jq \
		csvtool \
		libxml2-utils

###### Variables affecting the image building
ENV SDAAS_INSTALL_DIR=/opt/sdaas
ENV SDAAS_WORKSPACE=/workspace
ENV SDAAS_ETC="/etc/sdaas"

###### SDAAS constant the image building
ENV SDAAS_REFERENCE_DOC="https://sdaas.netlify.app/reference/command"
ENV SDAAS_VERSION="4.0"
ENV SDAAS_VERSION_NAME="Pitagora"

COPY modules "$SDAAS_INSTALL_DIR"
COPY bin/sdaas /usr/bin/sdaas
COPY etc/sdaas "${SDAAS_ETC}"
RUN chmod -R 0755 /usr/bin/sdaas

RUN useradd -m -d /workspace -s /bin/bash -g users -u 1001 sdaas
USER sdaas
WORKDIR "${SDAAS_WORKSPACE}"

## Variables affecting program execution
ENV SD_LOG_PRIORITY=6


# Uncomment this to change the default web agent signature
#ENV SD_APPLICATION_ID="example.org SDaaS"

ENTRYPOINT ["/usr/bin/sdaas"]