#!/usr/bin/env bats

function setup {
	for stub in asserting caching kb date; do
		. "$BATS_TEST_DIRNAME/stubs/${stub}_stub.include"
	done
	SD_INCLUDE logging
	SD_INCLUDE reasoning
	CREATE_STUB_CACHE
}

function teardown {
	if [  $SD_DEBUG -eq 0 ]; then DROP_STUB_CACHE ; fi
}


@test "SD_EVAL_CONSTRUCTOR" {
	run SD_EVAL_CONSTRUCTOR  graph constructor "$SD_CACHE/eval_constructor.ttl"
	#echo "$output" > /tmp/x
	[[ "${lines[0]}" =~ 'reasoning on graph <graph>' ]]
	[[ "${lines[1]}" =~ 'evaluating axiom constructor...' ]]
	[  "${lines[2]}" =  'SD_SPARQL_QUERY text/turtle constructor' ]
	[[ "${lines[3]}" =~ 'completed by replacing graph <graph>' ]]
	[  "${lines[4]}" =  'SD_SPARQL_UPDATE DROP SILENT GRAPH <graph>' ]
	[[ "${lines[5]}" =~ 'SD_LOAD_RDF_FILE graph' ]]
}
