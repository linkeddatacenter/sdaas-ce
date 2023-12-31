#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	TESTSTORE="http://kb:8080/sdaas/sparql"
	INSERT_TEST_STATEMENT='INSERT DATA { GRAPH <urn:graph:g> { <urn:uri:s> <urn:uri:p> <urn:uri:o>} }'
	sd_include w3c
}

on_script_startup

function setup {
	sd_w3c_erase TESTSTORE
}



@test "sd_w3c_update insert data" {
	run sd_w3c_update TESTSTORE "$INSERT_TEST_STATEMENT"
    [[ "$status" -eq 0 ]]
	[[ "$(sd_w3c_size TESTSTORE)" -eq 1 ]]
}


@test "sd_w3c_update wrong statement" {
	run sd_w3c_update TESTSTORE "NO UPDATE STATEMENT"
    [[ "$status" -ne 0 ]]
    [[ "${lines[0]}" =~  ERROR ]]
	[[ "$(sd_w3c_size TESTSTORE)" -eq 0 ]]
}



@test "sd_w3c_query inserted data" {
	sd_w3c_update TESTSTORE "$INSERT_TEST_STATEMENT"
	run sd_w3c_query TESTSTORE "text/csv" "SELECT ?s ?p ?o { ?s ?p ?o }"
    [[ "$status" -eq 0 ]]
    [[ "${lines[0]}" =~  "s,p,o" ]]
    [[ "${lines[1]}" =~  "urn:uri:s,urn:uri:p,urn:uri:o" ]]
}




