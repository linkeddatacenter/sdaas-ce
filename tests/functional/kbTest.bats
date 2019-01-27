#!/usr/bin/env bats

function doTest {
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
				<urn:s:1> <urn:p:1> <urn:o:1>,<urn:o:2> .
			}
		}
	'
	SD_SPARQL_QUERY 'application/sparql-results+xml' 'ASK { GRAPH <urn:graph:geoexample> {?s ?p ?o}}'
	SD_SPARQL_QUERY 'application/sparql-results+xml' 'ASK { GRAPH <urn:graph:urnexample> {<urn:s:1> <urn:p:1> <urn:o:1>}}'
}


@test "KB test" {
	run doTest
	#>&2 echo "$output"
	[ $status -eq 0 ]
	[[ $output =~ "<boolean>true</boolean>" ]]
}
