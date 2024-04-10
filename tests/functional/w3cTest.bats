#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	TESTSTORE="http://kb:8080/sdaas/sparql"
	TESTSTORE_TYPE="w3c"
	INSERT_TEST_STATEMENT="
# This is a comment to ensure new lines are evaluated
INSERT DATA { GRAPH <urn:graph:g> { <urn:uri:s> <urn:uri:p> <urn:uri:o>} }
"
	sd_include w3c
}

on_script_startup

function setup {
	sd_w3c_erase TESTSTORE
}


function test {
	local statement="$1"
	shift 1

	echo "$statement" | "$@"
}



@test "sd_w3c_update insert data" {
	run test "$INSERT_TEST_STATEMENT" sd_w3c_update TESTSTORE 
    [[ "$status" -eq 0 ]]
	[[ "$(sd_w3c_size TESTSTORE)" -eq 1 ]]
}


@test "sd_w3c_update wrong statement" {
	run test "NO UPDATE STATEMENT"  sd_w3c_update TESTSTORE
    [[ "$status" -ne 0 ]]
    [[ "${lines[0]}" =~  ERROR ]]
	[[ "$(sd_w3c_size TESTSTORE)" -eq 0 ]]
}



@test "sd_w3c_query inserted data" {
	echo "$INSERT_TEST_STATEMENT" | sd_w3c_update TESTSTORE 
	run test "SELECT ?s ?p ?o { ?s ?p ?o }" sd_w3c_query TESTSTORE "text/csv" 
    [[ "$status" -eq 0 ]]
    [[ "${lines[0]}" =~  "s,p,o" ]]
    [[ "${lines[1]}" =~  "urn:uri:s,urn:uri:p,urn:uri:o" ]]
}




