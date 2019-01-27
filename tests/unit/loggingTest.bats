#!/usr/bin/env bats

function setup {
	for  stub in asserting caching date; do
		. "$BATS_TEST_DIRNAME/stubs/${stub}_stub.include"
	done
	CREATE_STUB_CACHE
	SD_INCLUDE logging
}


function teardown {
	DROP_STUB_CACHE
}


@test "SD_START_LOGGING" {
	SD_DEBUG_FILE="$SD_CACHE/session_1.debug"
	SD_LOG_FILE="$SD_CACHE/session_1.log"
	SD_START_LOGGING 
	[ -f "$SD_CACHE/session_1.log"  ]
	[ -f "$SD_CACHE/session_1.debug"  ]
}



@test "SD_SHOW" {
	run SD_SHOW hello
	[ "$output" = "hello" ]
}


@test "SD_SHOW silent" {
	SD_VERBOSE=0
	run SD_SHOW hello
	[ "$output" = "" ]
}


@test "SD_LOG" {
	SD_LOG_FILE="$SD_CACHE/session_0.log"
	run SD_LOG hello
	[ "$output" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - hello" ]
	run cat "$SD_CACHE/session_0.log"
	[ "$output" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - hello" ]
}


@test "SD_LOG only on file" {
	SD_LOG_FILE="$SD_CACHE/session_0.log"
	run SD_LOG "hello1" silent
	run SD_LOG "hello2" silent
	[ "$output" = "" ]
	run cat "$SD_CACHE/session_0.log"
	[ "${lines[0]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - hello1" ]
	[ "${lines[1]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - hello2" ]
}


@test "SD_DEBUG_INFO" {
	SD_DEBUG=1
	SD_DEBUG_FILE="$SD_CACHE/session_2.debug"
	run SD_DEBUG_INFO "hello1"
	run SD_DEBUG_INFO "hello2"
	[ "$output" = "" ]
	run cat "$SD_CACHE/session_2.debug"
	[ "${lines[0]}" = "hello1" ]
	[ "${lines[1]}" = "hello2" ]	
}


@test "SD_MK_DEBUG_TMP_FILE" {
	tmpFile=$(SD_MK_DEBUG_TMP_FILE test)
	[[ $tmpFile =~ ^$SD_CACHE/test ]]
}