#!/usr/bin/env bats


function on_script_startup {
	STORE="http://kb:8080/sdaas/sparql"
	STORE_TYPE="w3c"
	SD_LOG_PRIORITY=3
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
}

on_script_startup



@test "step1: drop all" {
	run sd sparql update "DROP ALL"
	[[ "$status" -eq 0 ]]
	[[ "$(sd driver size STORE)" -eq 0 ]]
}

@test "step2: load from sparql update" {
	run sd sparql update 'LOAD <https://dbpedia.org/data/Lecco.ttl> INTO GRAPH <urn:graph:0>'
	[[ "$status" -eq 0 ]]
	[[ "$(sd driver size STORE)" -eq 1205 ]]
}

@test "step3: load from resource" {
	function pipe_load {
		sd_core_ontology | sd sparql graph "urn:graph:1"
	}
	
	run pipe_load
	[[ "$status" -eq 0 ]]
	[[ "$(sd driver size STORE)" -eq 1346 ]]
}


@test "step4: query" {
	run sd sparql query -o csv "SELECT ?g (COUNT (?s) AS ?subjects) WHERE {GRAPH ?g{?s?p ?o}} GROUP BY ?g order by ?g"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "g,subjects" ]]
	[[ "$(sd driver size STORE)" -eq 1346 ]]
	[[ "${lines[1]}" == "urn:graph:0,1205" ]]
	[[ "${lines[2]}" == "urn:graph:1,141" ]]
}

@test "step5: query by streamed command" {
	run sd sparql query -o csv "SELECT DISTINCT ?class WHERE { ?s a ?class} LIMIT 10"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "class" ]]
	[[ "${#lines[@]}" -eq 11 ]]
}



