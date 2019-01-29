#!/usr/bin/env bats

function setup {
	SD_CACHE='/tmp/ftest'
	SD_LOG_FILE="$SD_CACHE/session.log"
	SD_DEBUG_FILE="$SD_CACHE/session.debug"
	. "$BATS_TEST_DIRNAME/../../scripts/platform.include"

	
	SD_BEGIN_INGESTION
	SD_SPARQL_UPDATE "DROP ALL"
	SD_LOAD_RDF_FILE urn:graph:geoexample "$BATS_TEST_DIRNAME/data/geo.ttl"
	SD_SPARQL_UPDATE '
		INSERT DATA {
			GRAPH <urn:graph:urnexample> {
				<urn:s:1> <urn:p:1> <urn:o:1>,<urn:o:2>,<urn:o:3> .
			}
		}
	'
}


@test "KB query test 1" {
	run SD_SPARQL_QUERY 'application/sparql-results+xml' 'ASK { GRAPH <urn:graph:geoexample> {?s ?p ?o}}'	
	[ $status -eq 0 ]
	[[ $output =~ "<boolean>true</boolean>" ]]
}



@test "KB query test 2" {
	run SD_SPARQL_QUERY 'application/sparql-results+xml' 'ASK { GRAPH <urn:graph:urnexample> {<urn:s:1> <urn:p:1> <urn:o:1>}}'
	[ $status -eq 0 ]
	[[ $output =~ "<boolean>true</boolean>" ]]
}



@test "KB query test 3" {
	run SD_SPARQL_QUERY bool 'ASK { GRAPH <urn:graph:urnexample> {<urn:s:1> <urn:p:1> <urn:o:1>}}'
	[ $status -eq 0 ]
	[ $output = "true" ]
}



@test "KB query test 4" {
	run SD_SPARQL_QUERY bool 'ASK { GRAPH <urn:graph:urnexample> {<urn:s:1> <urn:p:2> <urn:o:1>}}'
	[ $status -eq 0 ]
	[ $output = "false" ]
}



@test "KB query test 5" {
	run SD_SPARQL_QUERY csv-f1 'SELECT ?s ?p {?s ?p <urn:o:1>}'
	[ $status -eq 0 ]
	[ $output = "urn:s:1" ]
}

