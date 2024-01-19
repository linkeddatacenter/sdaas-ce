#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	sd_include driver
}

on_script_startup



########## sd_driver_validate


@test "driver sd_driver_validate with missing endpoint" {
	run sd_driver_validate MYSID
	[[ "$status" -ne 0 ]]
}


@test "driver sd_driver_validate with invalid endpoint syntax" {
	local MYSID="ftp://query.wikidata.org/sparql"
	run sd_driver_validate MYSID
	[[ "$status" -ne 0 ]]
}


@test "driver sd_driver_validate to a store without driver" {
	local MYTEST="http://example.org/sparql"
	[[ -z "$MYTEST_TYPE" ]]
	sd_driver_validate MYTEST
	[[ "$MYTEST_TYPE" == "w3c" ]]
}


@test "driver sd_driver_validate to a store with valid driver" {
	local TEST="http://example/sparql"
	local TEST_TYPE="testdriver"
	run sd_driver_validate TEST 
    [[ "$status" -eq 0 ]]
}


@test "driver sd_driver_validate to an invalid driver" {
	local TEST="http://example/sparql"
	local TEST_TYPE="notexists"
	run sd_driver_validate TEST 
    [[ "$status" -ne 0 ]]
}


@test "driver sd_driver_validate gsp without endpoint" {
	local TEST="http://example/sparql"
	local TEST_TYPE="gsp"
	run sd_driver_validate TEST 
    [[ "$status" -ne 0 ]]
}


##########  sd_driver_update

@test "driver sd_driver_update" {
	local TEST="http://example/sparql"
	local TEST_TYPE="testdriver"
	run sd_driver_update TEST
    [[ "$status" -eq 0 ]]
}

@test "driver sd_driver_update invalid sid" {
	run sd_driver_update NOSTORE
    [[ "$status" -eq 1 ]]
}

########## sd_driver_query

@test "driver sd_driver_query" {
	local TEST="http://example/sparql"
	local TEST_TYPE="testdriver"
	run sd_driver_query TEST "text/csv"
    [[ "$status" -eq 0 ]]
}


@test "driver sd_driver_query invalid sid" {
	run sd_driver_query INVALIDSID "text/csv"
    [[ "$status" -gt 0 ]]
}



@test "driver sd_driver_query missing mimetype" {
	run sd_driver_query STORE
    [[ "$status" -gt 0 ]]
}