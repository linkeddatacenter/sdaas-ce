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

COPY modules "$SDAAS_INSTALL_DIR"
COPY bin/sdaas /usr/bin/sdaas
COPY /etc/* /etc/
RUN chmod -R 0755 /usr/bin/sdaas

RUN useradd -m -d /workspace -s /bin/bash -g users -u 1001 sdaas
USER sdaas
WORKDIR "${SDAAS_WORKSPACE}"

## Variables affecting program execution
ENV SD_LOG_PRIORITY=6
ENV SD_TMP_DIR="/tmp"

# Uncomment this to change the default web agent signature
#ENV SD_APPLICATION_ID="example.org SDaaS"

ENTRYPOINT ["/usr/bin/sdaas"]