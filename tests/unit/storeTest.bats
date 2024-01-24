#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	STORE=http://dummy.example.org/sparql
	STORE_TYPE=testdriver
	sd_include store
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


@test "sd_store_erase interface " {
	test_sid sd_store_erase
}



@test "sd_store_size interface " {
	test_sid sd_store_size
}