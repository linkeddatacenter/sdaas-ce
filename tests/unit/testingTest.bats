#!/usr/bin/env bats

function setup {
	for stub in asserting caching kb date; do
		. "$BATS_TEST_DIRNAME/stubs/${stub}_stub.include"
	done
	SD_INCLUDE testing
	SD_INCLUDE logging
	CREATE_STUB_CACHE
}

function teardown {
	if [  $SD_DEBUG -eq 0 ]; then DROP_STUB_CACHE ; fi
}


@test "SD_DATA_TEST" {
	run SD_DATA_TEST  tests/unit/data/testing 
	#echo "$output" > /tmp/x
	[[ "${lines[0]}" =~ 'sdaas Sun Dec 24 00:00:00 UTC 2017 - Testing knowledge graph integrity...' ]]
	[[ "${lines[1]}" =~ '01_test.ask...SD_SPARQL_QUERY xml @tests/unit/data/testing/01_test.ask' ]]
	[[ "${lines[2]}" =~ '02_test.ask...SD_SPARQL_QUERY xml @tests/unit/data/testing/02_test.ask' ]]
	[[ "${lines[3]}" =~ '03_test.select...SD_SPARQL_QUERY csv-h @tests/unit/data/testing/03_test.select' ]]
}