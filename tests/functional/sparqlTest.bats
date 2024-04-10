#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	STORE="http://kb:8080/sdaas/sparql"
	STORE_TYPE=w3c
	INSERT_TEST_STATEMENT="
# This is a comment to ensure new lines are evaluated
INSERT DATA { GRAPH <urn:graph:g> { <urn:uri:s> <urn:uri:p> <urn:uri:o>} }
"
	sd_include sparql
}

on_script_startup


function setup {
	sd_driver_erase STORE
}



function test {
	local statement="$1"
	shift 1

	echo "$statement" | "$@"
}



##########  sd_sparql_update

@test "sd_sparql_update insert data" {
	run test "$INSERT_TEST_STATEMENT"  sd_sparql_update
    [[ "$status" -eq 0 ]]
	[[ "$(sd_driver_size STORE)" -eq 1 ]]
}

@test "sd_sparql_update wrong statement" {
	run test  "NO UPDATE STATEMENT"  sd_sparql_update
    [[ "$status" -ne 0 ]]
	[[ "$(sd_driver_size STORE)" -eq 0 ]]
}


########## sd_sparql_query


@test "sd_sparql_query inserted data" {
	echo "$INSERT_TEST_STATEMENT" | sd_sparql_update 
	run test "SELECT ?s ?p ?o { ?s ?p ?o }" sd_sparql_query -o "csv-h" 
    [[ "$status" -eq 0 ]]
    [[ "${lines[0]}" ==  "urn:uri:s,urn:uri:p,urn:uri:o" ]]
}



@test "sd_sparql_query with wrong statement" {
	run test "xxxx" sd_sparql_query -o "csv-h" 
    [[ "$status" -ne 0 ]]
}


########## sd_sparql_graph

@test "sd_sparql_graph bad stream " {
	run test "xxx" sd_sparql_graph -a PUT "urn:graph:store"
    [[ "$status" -ne 0 ]]
}

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