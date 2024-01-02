#!/usr/bin/env bats

function on_script_startup {
	_SAVED_PRIORITY="$SD_LOG_PRIORITY"
	SD_LOG_PRIORITY=2
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH

	# this allow reload of local commands
	sd_include -f core
}

on_script_startup

function setup {
	SD_LOG_PRIORITY=2
}


function teardown {
	SD_LOG_PRIORITY="$_SAVED_PRIORITY"
}


########## Test sd_log 

@test "core sd_log with default priority" {
	SD_LOG_PRIORITY=7
	run sd_log "test message as NOTICE"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" =~ NOTICE.+test\ message\ as\ NOTICE$ ]]
}


@test "core sd_log with ERROR priority" {
	SD_LOG_PRIORITY=7
	run sd_log -p ERROR "test message as ERROR"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" =~ ERROR.+test\ message\ as\ ERROR ]]
}


@test "core sd_log with 3 priority" {
	SD_LOG_PRIORITY=7
	run sd_log -p 3 "test message as ERROR"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" =~ ERROR.+test\ message\ as\ ERROR$ ]]
}


@test "core sd_log with file" {
	SD_LOG_PRIORITY=7
	echo "test line 1" > /tmp/sd_log_test_file.txt
	run sd_log -p ERROR -f /tmp/sd_log_test_file.txt "file as ERROR"
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" =~ file\ as\ ERROR$ ]]
	[[ "${lines[1]}" == 'test line 1' ]]
	run rm /tmp/sd_log_test_file.txt
	[[ "$status" -eq 0 ]]
}



########## Test sd_validate

@test "core sd_validate ok" {
	local MYSTORE="http://test:9090/xxx/sparql"
	local MYSTORE_TYPE=w3c
	local sid=MYSTORE
	run sd_validate sid "^[a-zA-Z]+$"
	[ "$status" -eq 0 ]
	run sd_validate "$sid" "^http://"
	[ "$status" -eq 0 ]
	run sd_validate MYSTORE_TYPE "^w3c$"
}



@test "core sd_validate ko" {
	local MYSTORE="http://test:9090/xxx/sparql"
	local sid=MYSTORE
	run sd_validate "$sid" "^[a-zA-Z]+$"
	[[ "$status" -ne 0 ]]
}

########## Test sd_abort

@test "core sd_abort" {
	run sd_abort HALT
	[[ "$status" -eq 2 ]]
}


########## Test sd

@test "core sd with base params" {
	run sd core version
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "$SDAAS_VERSION" ]]
}



@test "core sd or direct command must provide the same result" {
	local res=$(sd core version)
	run sd_core_version
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "$res" ]]
}



@test "core sd abort on failing" {
	run sd -A NONESISTENT NONESISTENT
	[[ "$status" -ne 0 ]]
}


@test "core sd help" {
	run sd -h view modules
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "https://sdaas.netlify.app/reference/command/sd_view_modules" ]]
}

@test "sd core ontology" {
	run sd core ontology
	[[ "$status" -eq 0 ]]
	[[ ${lines[0]} =~ "<http://linkeddata.center/kees/v1>" ]]
	
	run sd core ontology -O ntriples
	[[ "$status" -eq 0 ]]
	[[ ${lines[0]} =~ "<http://linkeddata.center/kees/v1>" ]]
}


@test "sd core ontology  -O turtle" {
	run sd core ontology -O turtle
	[[ "$status" -eq 0 ]]
	[[ ${lines[0]} =~ "@base <urn:sdaas:tbox> ." ]]
}



@test "sd core ontology -O rdfxml" {
	run sd core ontology -O rdfxml
	[[ "$status" -eq 0 ]]
	[[ ${lines[0]} =~ "<?xml version=\"1.0\" encoding=\"utf-8\"?>" ]]
}