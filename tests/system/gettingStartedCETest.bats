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
	run sd sparql update 'LOAD <https://schema.org/version/latest/schemaorg-current-http.ttl> INTO GRAPH <urn:graph:0>'
	[[ "$status" -eq 0 ]]
	[[ "$(sd driver size STORE)" -eq 16389 ]]
}

@test "step3: load from resource" {
	run sd sparql graph -a PUT -r https://schema.org/version/latest/schemaorg-current-http.ttl "urn:graph:1"
	[[ "$status" -eq 0 ]]
	[[ "$(sd driver size STORE)" -eq 16389 ]]
}


@test "step4: query" {
	run sd sparql query -O csv "SELECT ?g (COUNT (?s) AS ?subjects) WHERE {GRAPH ?g{?s?p ?o}} GROUP BY ?g"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "g,subjects" ]]
	[[ "$(sd driver size STORE)" -eq 16389 ]]
	[[ "${lines[1]}" == "urn:graph:0,16389" ]]
	[[ "${lines[2]}" == "urn:graph:1,16389" ]]
}

@test "step5: query by streamed command" {
	run sd sparql query -O csv "SELECT DISTINCT ?class WHERE { ?s a ?class} LIMIT 10"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "class" ]]
	[[ "${#lines[@]}" -eq 11 ]]
}



