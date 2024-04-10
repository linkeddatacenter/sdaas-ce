#!/usr/bin/env bats

function on_script_startup {
	_SAVED_PRIORITY="$SD_LOG_PRIORITY"
	SD_LOG_PRIORITY=2
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
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


########## Test sd_error 

@test "core sd_error" {
	SD_LOG_PRIORITY=7
	run sd_error "test message as ERROR" 3
	[[ "$status" -eq 3 ]]
	[[ "${lines[0]}" =~ "[ERROR]" ]]
	[[ "${lines[0]}" =~ "test message as ERROR" ]]
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

@test "test SD" {
	run sd view version
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "$SDAAS_VERSION" ]]
}


@test "core sd abort on failing" {
	run sd -A NONESISTENT NONESISTENT
	[[ "$status" -ne 0 ]]
}


@test "core sd help" {
	run sd -h view modules
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "https://linkeddata.center/sdaas/reference/sd_view_modules" ]]
}

########## Test sd_url_encode

@test "sd_url_encode" {
	run sd_url_encode "http://w3.org/?test#name"
	[ "$status" -eq 0 ]
	[[ "${lines[0]}" == "http%3A%2F%2Fw3.org%2F%3Ftest%23name" ]]
}


########## sd_return_first_non_zero

@test "sd_return_first_non_zero" {
	
	#run sd_return_first_non_zero 0 
	#[ "$status" -eq 0 ]

	run sd_return_first_non_zero 0 0 0 0
	[ "$status" -eq 0 ]
	
	run sd_return_first_non_zero 0 1 2 3
	[ "$status" -eq 1 ]
	
	run sd_return_first_non_zero 0 0 2 3
	[ "$status" -eq 2 ]
}
