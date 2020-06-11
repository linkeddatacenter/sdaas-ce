#!/usr/bin/env bash
# Copyright (C) 2020 LinkedData.Center - All Rights Reserved
# Permission to copy and modify is granted under the MIT license

export _SD_LOCAL_REASONER_STARTED=0


if [ ${SD_NOWARMUP:=0} -ne 1 ]; then
	/sdaas-start -d --size ${SDAAS_SIZE:-micro}
	_SD_LOCAL_REASONER_STARTED=1
fi


# priority to local override of the sdaas scripts
if [ -d "${SDAAS_WORKSPACE:=/workspace}/scripts/sdaas" ]; then
	echo "Running SDaaS from workspace"
	exec "${SDAAS_WORKSPACE}/scripts/sdaas"  "$@"
else
	exec $SDAAS_BIN_DIR/sdaas "$@"
fi
