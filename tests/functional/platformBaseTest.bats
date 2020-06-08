#!/usr/bin/env bats


@test "SDAAS platform inclusion" {
	SD_CACHE='/tmp/ftest'
	SD_LOG_FILE="$SD_CACHE/session.log"
	SD_DEBUG_FILE="$SD_CACHE/session.debug"
	. "$BATS_TEST_DIRNAME/../../scripts/platform.include"
	run echo "OK"
	[ ! -f  .env ]
	[ -f  /tmp/ftest/session.log ]
	[ -f  /tmp/ftest/session.debug ]
	[ ! -z "$SD_DEBUG" ]
	[ $__module_caching -eq 1 ]
	[ $__module_logging -eq 1 ]
	[ $__module_bg_reasoning -eq 1 ]
	[ $__module_kb -eq 1 ]
	[ $__module_learning -eq 1 ]
}
