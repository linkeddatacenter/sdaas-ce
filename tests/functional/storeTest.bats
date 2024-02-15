#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	STORE="http://kb:8080/sdaas/sparql"
	STORE_TYPE=w3c
	sd_include store
}

on_script_startup



@test "sd_store_erase " {
	run sd_store_erase
    [[ "$status" -eq 0 ]]
	[[ "$(sd_driver_size STORE)" -eq 0 ]]
}


@test "sd_store_size" {
	echo 'INSERT DATA { GRAPH <urn:graph:g> { <urn:uri:s> <urn:uri:p> <urn:uri:o>} }' | sd sparql update 
	run sd_store_size
    [[ "$status" -eq 0 ]]
	[[ "${lines[0]}" -eq 1 ]]
}
