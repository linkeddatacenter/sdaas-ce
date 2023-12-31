#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	STORE=http://dummy.example.org/sparql
	STORE_TYPE=testdriver
	sd_include sparql
	load testsid.include
}

on_script_startup


##########  sd_sparql_update


@test "sd_sparql_update sid management" {
	test_sid sd_sparql_update "STATEMENT"
}


########## sd_sparql_query


@test "sd_sparql_query sid management" {
	test_sid sd_sparql_query "STATEMENT"
}





########## sd_sparql_graph


@test "sd_sparql_graph sid management" {
	test_sid sd_sparql_graph -f ntriples -a PUT -r "@tests/data/empty-store.nt" "urn:graph:store"
}



@test "sd_sparql_graph from stream " {
	cat "tests/data/empty-store.nt" |  sd_sparql_graph -a PUT "urn:graph:store"
    [[ "$status" -eq 0 ]] 
}


@test "sd_sparql_graph with extra option" {
	run sd_sparql_graph -x -f ntriples -a PUT -r "@tests/data/empty-store.nt" "urn:graph:store"
    [[ "$status" -ne 0 ]] 
}

