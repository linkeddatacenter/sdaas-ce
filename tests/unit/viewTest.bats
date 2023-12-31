#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	sd_include view
}

on_script_startup


@test "view modules" {
	run sd view modules
	[[ "$status" -eq 0 ]]
	[[ ${#lines[@]} -ge 6 ]]
}



@test "view modules extra argument" {
	run sd view modules xxx
	[[ "$status" -ne 0 ]]
	[[ ${output} =~ ERROR ]]
}



@test "view module" {
	run sd view module view
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -ge 3 ]
}



@test "view module with missing module" {
	run sd view module
	[ "$status" -ne 0 ]
	[[ ${output} =~ ERROR ]]
}


@test "view config" {
	run sd view config
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -gt 1 ]
}

@test "view config with extra param" {
	run sd view config xxx
	[ "$status" -ne 0 ]
	[[ ${output} =~ ERROR ]]
}

