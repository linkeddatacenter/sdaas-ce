#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	STORE=http://dummy.example.org/sparql
	STORE_TYPE=testdriver
	sd_include sparql
}

on_script_startup


function test_sid {
	local cmd="$1"
	shift 1

	# Tests setup
	local MYSTORE="$STORE" MYSTORE_TYPE="testdriver"

	run "$cmd" "$@"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "STORE" ]]

	run "$cmd" -s MYSTORE "$@"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "MYSTORE" ]]

	run "$cmd" -D "sid=MYSTORE"  "$@"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "MYSTORE" ]]
	
	# test with bad store
	run "$cmd" -s NOTEXIST  "$@"
	[[ "$status" -eq 1 ]]

	run "$cmd"  -D "sid=NOTEXIST"  "$@"
	[[ "$status" -eq 1 ]]

	# test precendences
	run "$cmd" -D "sid=NOTEXIST" -s STORE "$@"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "STORE" ]]

	run "$cmd" -s NOTEXIST -D "sid=STORE"  "$@"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "STORE" ]]

}


##########  sd_sparql_update

@test "sd_sparql_update interface " {
	test_sid sd_sparql_update
}


########## sd_sparql_query

@test "sd_sparql_query sid management" {
	test_sid sd_sparql_query "STATEMENT"
}


########## sd_sparql_graph

@test "sd_sparql_graph sid management" {
	test_sid sd_sparql_graph -a PUT "urn:graph:store"
}


@test "sd_sparql_graph from stream " {
	cat "tests/data/empty-store.nt" |  sd_sparql_graph -a PUT "urn:graph:store"
    [[ "$status" -eq 0 ]] 
}


@test "sd_sparql_graph with extra option" {
	run sd_sparql_graph -x -i ntriples -a PUT -I "@tests/data/empty-store.nt" "urn:graph:store"
    [[ "$status" -ne 0 ]] 
}
