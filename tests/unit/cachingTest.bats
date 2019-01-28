#!/usr/bin/env bats

function setup {
	. "$BATS_TEST_DIRNAME/stubs/asserting_stub.include"
	rm -rf /tmp/testcleancache
	SD_INCLUDE caching
}

@test "SD_CACHE default" {
  [ "$SD_CACHE"=".cache" ]
}


@test "SD_CLEAN_CACHE in custom position" {
	SD_CACHE=/tmp/testcleancache/dir
	run SD_CLEAN_CACHE
	[ "$status" -eq 0 ]
	[ -d /tmp/testcleancache/dir ]
	rm -rf /tmp/testcleancache	
}


#@test "SD_CLEAN_CACHE unwritable" {
#    SD_CACHE="/nonexistingdir"
#	run SD_CLEAN_CACHE
#	[ "$status" -eq 2 ]
#	[ ! -f "/nonexistingdir" ]
#}


@test "SD_CLEAN_CACHE is cleaned" {
	SD_CACHE=/tmp/testcleancache/dir
	run SD_CLEAN_CACHE
	[ "$status" -eq 0 ]
	
	touch $SD_CACHE/file1
	run SD_CLEAN_CACHE
	[ "$status" -eq 0 ]
	[ ! -f "$SD_CACHE/file1" ]
	rm -rf /tmp/testcleancache	
}

