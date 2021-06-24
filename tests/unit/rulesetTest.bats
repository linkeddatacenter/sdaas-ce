#!/usr/bin/env bats

function setup {
	for stub in asserting caching kb date; do
		. "$BATS_TEST_DIRNAME/stubs/${stub}_stub.include"
	done
	SD_INCLUDE logging
	SD_INCLUDE learning
	SD_INCLUDE reasoning
	SD_INCLUDE ruleset
	CREATE_STUB_CACHE
}

function teardown {
	if [  $SD_DEBUG -eq 0 ]; then DROP_STUB_CACHE ; fi
}


@test "SD_EVAL_RULESET" {
	run SD_EVAL_RULESET  urn:graph: tests/unit/data/01_ruleset 
	#echo "$output" > /tmp/x
	[[ "${lines[0]}" =~ 'starded inferencing axiom 1_test from  ruleset 01_ruleset' ]]
	[[ "${lines[1]}" =~ 'evaluating axiom @tests/unit/data/01_ruleset/1_test.construct...' ]]
	[[ "${lines[2]}" =~ 'SD_SPARQL_QUERY text/turtle @tests/unit/data/01_ruleset/1_test.construct' ]]
	[[ "${lines[3]}" =~ 'completed by replacing graph <urn:graph:tests/unit/data/01_ruleset/1_test.construct>' ]]
	[[ "${lines[4]}" =~ 'SD_SPARQL_UPDATE DROP SILENT GRAPH <urn:graph:tests/unit/data/01_ruleset/1_test.construct>' ]]
	[[ "${lines[5]}" =~ 'SD_LOAD_RDF_FILE urn:graph:tests/unit/data/01_ruleset/1_test.construct' ]]
	[[ "${lines[6]}" =~ 'SD_LOAD_RDF_FILE urn:graph:tests/unit/data/01_ruleset/1_test.construct' ]]
	[[ "${lines[7]}" =~ 'starded inferencing axiom 2_test from  ruleset 01_ruleset' ]]
	[[ "${lines[8]}" =~ 'SD_SPARQL_UPDATE @-' ]]
	[[ "${lines[9]}" =~ 'SD_LOAD_RDF_FILE urn:graph:tests/unit/data/01_ruleset/2_test.update /tmp/stub_cache/' ]]
	[[ "${lines[10]}" =~ 'starded inferencing axiom 3_test from  ruleset 01_ruleset' ]]
	[[ "${lines[11]}" =~ 'SD_SPARQL_UPDATE DROP SILENT GRAPH <urn:graph:tests/unit/data/01_ruleset/3_test.reasoning>' ]]
	[[ "${lines[12]}" =~ 'SD_LOAD_RDF_FILE urn:graph:tests/unit/data/01_ruleset/3_test.reasoning' ]]
}
