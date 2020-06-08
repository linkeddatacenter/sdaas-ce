#!/usr/bin/env bats

function setup {
	for stub in asserting caching gzip curl chmod ; do
		. "$BATS_TEST_DIRNAME/stubs/${stub}_stub.include"
	done
	
	SD_REASONER_ENDPOINT="http://localhost:8080/sdaas"
	STUB_CURL="--cmd"
	SD_INCLUDE logging
	SD_INCLUDE bg_reasoning true
	CREATE_STUB_CACHE
}

function teardown {
	DROP_STUB_CACHE
}


@test "No SD_CREATE_REASONER for kb" {	
	run SD_CREATE_REASONER kb
	[ "$status" -ne 0 ]
}


@test "no SD_DESTROY_REASONER" { 
	run SD_DESTROY_REASONER "$SD_REASONER_ENDPOINT"
	[ "$status" -ne 0 ]
}



@test "SD_REASONER_QUERY" {
	run SD_REASONER_QUERY "$SD_REASONER_ENDPOINT/sparql" 'text/csv' '@query' 'tracefile'
	[[ ${lines[0]} =~ "--header Content-Type: application/sparql-query" ]]
}



@test "SD_REASONER_LOAD" {
	run SD_REASONER_LOAD  "$SD_REASONER_ENDPOINT/sparql" graph "$BATS_TEST_DIRNAME/data/two_triples.nt" guess 
	#echo "$output" > /tmp/x.out
	[[ ${lines[0]} = "gzip -c $BATS_TEST_DIRNAME/data/two_triples.nt" ]]
	[[ ${lines[1]} = *"LOAD <file://"*".nt.gz> INTO GRAPH <graph>"* ]]
}

