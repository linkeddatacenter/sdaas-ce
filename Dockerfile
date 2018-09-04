FROM  lyrasis/blazegraph:2.1.4

LABEL authors="enrico@linkeddata.center"

USER root

ENV SDAAS_BIN_DIR /usr/local/bin/sdaas
ENV PATH="${SDAAS_BIN_DIR}:${PATH}"


# load regular linux tools required by sdaas:
# see https://wiki.alpinelinux.org/wiki/How_to_get_regular_stuff_working
RUN apk --no-cache add \
	bash \
	binutils \
	coreutils \
	curl \
	findutils \
	gawk \
	grep \
	openssl \
	php7 \
	raptor2 \
	sed \
	sudo \
	unzip \
	util-linux


# unpack and rename the blazegraph webapp
RUN unzip ${JETTY_WEBAPPS}/bigdata.war -d ${JETTY_WEBAPPS}/sdaas; \
	rm -f ${JETTY_WEBAPPS}/bigdata.war


COPY boilerplate /workspace
COPY writable-web.xml /writable-web.xml
COPY readonly-web.xml /readonly-web.xml
COPY sdaas-bin $SDAAS_BIN_DIR
RUN chmod -R 0755 $SDAAS_BIN_DIR

WORKDIR  /workspace

CMD sdaas-start --foreground
