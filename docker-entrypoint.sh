#!/usr/bin/env bash
# Copyright (C) 2020 LinkedData.Center - All Rights Reserved
# Permission to copy and modify is granted under the MIT license

export _SD_LOCAL_REASONER_STARTED=0


if [ ${SD_NOWARMUP:=0} -ne 1 ]; then
	/sdaas-start --size "${SDAAS_SIZE:-micro}" >> "$SDAAS_LOG_DIR/rdfstore.log"  2>&1 &
	_SD_LOCAL_REASONER_STARTED=1
	echo "SDaaS local reasoner engine started with $SDAAS_SIZE memory footprint. Logs in $SDAAS_LOG_DIR/rdfstore.log"
fi


# priority to local override of the sdaas scripts
if [ -f /workspace/scripts/sdaas ]; then
	echo "Running SDaaS from /workspace"
	exec /workspace/scripts/sdaas  "$@"
else
	exec $SDAAS_BIN_DIR/sdaas "$@"
fi
