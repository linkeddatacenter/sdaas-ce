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
	[ "${lines[0]}" = 'sdaas Sun Dec 24 00:00:00 UTC 2017 - Evaluating axiom constructor ...' ]
	[ "${lines[1]}" = 'SD_SPARQL_QUERY text/turtle constructor' ]
	[ "${lines[2]}" = "SD_LOAD_RDF_FILE graph $SD_CACHE/eval_constructor.ttl turtle" ]
}
