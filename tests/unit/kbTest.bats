#!/usr/bin/env bats

function setup {
	for stub in asserting caching rapper gzip curl chmod service_registry; do
		. "$BATS_TEST_DIRNAME/stubs/${stub}_stub.include"
	done
	
	SD_REASONER_ENDPOINT="http://localhost:9999/blazegraph"
	STUB_CURL="--cmd"
	SD_INCLUDE logging
	SD_INCLUDE bg_reasoning true
	CREATE_STUB_CACHE
}

function teardown {
	DROP_STUB_CACHE
}


@test "SD_CREATE_REASONER for kb" {	
	run SD_CREATE_REASONER kb
	[[ ${lines[0]} =~ "curl -s -X POST --data-binary"  ]]
	[[ ${lines[3]} =~ "com.bigdata.rdf.sail.namespace=kb-"  ]]
	[[ ${lines[17]} =~ "--header Content-Type:text/plain http://localhost:9999/blazegraph/namespace"  ]]
}


@test "SD_DESTROY_REASONER" { 
	run SD_DESTROY_REASONER 1
	[[ ${lines[0]} =~ "curl -s -X DELETE an_endpoint/namespace/a_namespace"  ]]
}



@test "SD_REASONER_QUERY" {
	run SD_REASONER_QUERY 1 'text/csv' '@query' 'tracefile'
	[[ ${lines[0]} =~ "--header Content-Type: application/sparql-query" ]]
}



@test "SD_REASONER_LOAD" {
	run SD_REASONER_LOAD 1 "$BATS_TEST_DIRNAME/data/two_triples.nt" guess graph
	#echo "$output" > /tmp/x.out
	[[ ${lines[0]} = "gzip -c $BATS_TEST_DIRNAME/data/two_triples.nt" ]]
	[[ ${lines[1]} = *"LOAD <file://"*".nt.gz> INTO GRAPH <graph>"* ]]
}

