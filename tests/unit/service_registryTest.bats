#!/usr/bin/env bats

function setup {
	for stub in asserting caching; do
		. "$BATS_TEST_DIRNAME/stubs/${stub}_stub.include"
	done
	SD_INCLUDE logging
	SD_INCLUDE service_registry
	CREATE_STUB_CACHE
}

function teardown {
	DROP_STUB_CACHE
}


@test "SD_REGISTER_SERVICE with id" {
	run SD_REGISTER_SERVICE "test|a|b" test
	[ $status -eq 0 ]
	[ "$output" = "test" ]
	[ -f "$_SD_SERVICE_ARCHIVE/test" ]
	
	run cat "$_SD_SERVICE_ARCHIVE/test" 
	[ "$output" = "test|a|b" ]
}


@test "SD_FETCH_SERVICE" {
	run SD_REGISTER_SERVICE "test|d|e"
	[ $status -eq 0 ]
	id="$output"
	
	run SD_FETCH_SERVICE $id
	[ $status -eq 0 ]
	[ "$output" = "test|d|e" ]
}


@test "SD_UNREGISTER_SERVICE" {
	run SD_REGISTER_SERVICE "test|a|b" test
	[ $status -eq 0 ]
	id="$output"
	
	run SD_UNREGISTER_SERVICE $id
	[ ! -f "$_SD_SERVICE_ARCHIVE/test" ]
}
