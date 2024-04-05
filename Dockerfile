# Copyright (C) 2023 LinkedData.Center - All Rights Reserved
FROM ubuntu:22.04

LABEL authors="enrico@linkeddata.center"

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		curl \
		gettext-base \
		ca-certificates \
		raptor2-utils \
		jq \
		csvtool \
		libxml2-utils


###### Mandatory configuration variables
ENV SDAAS_INSTALL_DIR=/opt/sdaas
ENV SDAAS_ETC="/etc/sdaas"
ENV SDAAS_REFERENCE_DOC="https://linkeddata.center/sdaas"
ENV SDAAS_VERSION="4.0.0"
ENV SDAAS_APPLICATION_ID="Community Edition"

COPY modules "$SDAAS_INSTALL_DIR"
COPY bin/sdaas /usr/bin/sdaas
COPY etc/sdaas "${SDAAS_ETC}"
RUN chmod -R 0755 /usr/bin/sdaas


# Create  an user and a workspace
ENV SDAAS_WORKSPACE=/workspace
RUN useradd -m -d "${SDAAS_WORKSPACE}/" -s /bin/bash -g users -u 1001 sdaas


ARG MODE=test
RUN if [ "$MODE" = "test" ]; then \
	apt-get install -y bats; \
fi

USER sdaas
WORKDIR "${SDAAS_WORKSPACE}"

## Variables affecting program execution
ENV SD_LOG_PRIORITY=7


ENTRYPOINT ["/usr/bin/sdaas"]