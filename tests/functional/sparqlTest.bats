#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	STORE="http://kb:8080/sdaas/sparql"
	STORE_TYPE=w3c
	INSERT_TEST_STATEMENT='INSERT DATA { GRAPH <urn:graph:g> { <urn:uri:s> <urn:uri:p> <urn:uri:o>} }'
	sd_include sparql
}

on_script_startup


function setup {
	sd_driver_erase STORE
}


##########  sd_sparql_update

@test "sd_sparql_update insert data" {
	run sd_sparql_update "$INSERT_TEST_STATEMENT"
    [[ "$status" -eq 0 ]]
	[[ "$(sd_driver_size STORE)" -eq 1 ]]
}


@test "sd_sparql_update wrong statement" {
	run sd_sparql_update "NO UPDATE STATEMENT"
    [[ "$status" -ne 0 ]]
    [[ "${lines[0]}" =~  ^\[ERROR\] ]]
	[[ "$(sd_driver_size STORE)" -eq 0 ]]
}


########## sd_sparql_query


@test "sd_sparql_query inserted data" {
	sd_sparql_update "$INSERT_TEST_STATEMENT"
	run sd_sparql_query -o "csv-h" "SELECT ?s ?p ?o { ?s ?p ?o }"
    [[ "$status" -eq 0 ]]
    [[ "${lines[0]}" ==  "urn:uri:s,urn:uri:p,urn:uri:o" ]]
}



########## sd_sparql_graph


@test "sd_sparql_graph from stream " {
	cat "tests/data/empty-store.nt" | sd_sparql_graph -a PUT "urn:graph:store"
	[[ "$(sd_driver_size STORE)" -eq 41 ]]
}


@test "sd_sparql_graph with put" {
	cat "tests/data/empty-store.nt" | sd_sparql_graph -a PUT "urn:graph:store"
	[[ "$(sd_driver_size STORE)" -eq 41 ]]
	cat "tests/data/empty-store.nt" | sd_sparql_graph -a PUT "urn:graph:store"
	[[ "$(sd_driver_size STORE)" -eq 41 ]]
}

@test "sd_sparql_graph with post " {
	cat "tests/data/empty-store.nt" | sd_sparql_graph "urn:graph:store"
	[[ "$(sd_driver_size STORE)" -eq 41 ]]
	cat "tests/data/empty-store.nt" | sd_sparql_graph "urn:graph:store"
	[[ "$(sd_driver_size STORE)" -eq 82 ]]
}