#!/usr/bin/env bats

function setup {
	. scripts/asserting.include
}

@test "SD_VERBOSE default is 1" {
  [ "$SD_VERBOSE" -eq 1 ]
}

@test "SD_FATAL_ERROR is ok" {
	run SD_FATAL_ERROR "here error description"
	[ "$status" -eq 1 ]
	[ "$output" = "here error description" ]
}


@test "SD_REQUIRES_VAR with existing variable" {
	testvar=1
	run SD_REQUIRES_VAR SD_VERBOSE testvar
	[ $status -eq 0 ]
}


@test "SD_REQUIRES_VAR with not existing variable" {
	run SD_REQUIRES_VAR not_exists
	[ "$status" -gt 0 ]
	[ "$output" = "Mandatory environment variable not_exists not defined." ]
}


@test "SD_REQUIRES_CMD with  existing commands" {
	run SD_REQUIRES_CMD ls dir grep
	[ "$status" -eq 0 ]
}


@test "SD_REQUIRES_CMD with not existing command" {
	run SD_REQUIRES_CMD ls dir not_exists grep
	[ "$status" -eq 1 ]
	[ "$output" = "I require not_exists but it it's not installed." ]
}