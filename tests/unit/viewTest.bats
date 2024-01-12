#!/usr/bin/env bats

function on_script_startup {
	source "$SDAAS_INSTALL_DIR/core" NO_SPLASH
	sd_include view
}

on_script_startup


@test "view modules" {
	run sd_view_modules
	[[ "$status" -eq 0 ]]
	[[ ${#lines[@]} -ge 6 ]]
}



@test "view modules extra argument" {
	run sd_view_modules xxx
	[[ "$status" -ne 0 ]]
	[[ ${output} =~ ERROR ]]
}



@test "view module" {
	run sd_view_module view
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -ge 3 ]
}



@test "view module with missing module" {
	run sd_view_module
	[ "$status" -ne 0 ]
	[[ ${output} =~ ERROR ]]
}


@test "view config" {
	run sd_view_config
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -gt 1 ]
}

@test "view config with extra param" {
	run sd_view_config xxx
	[ "$status" -ne 0 ]
	[[ ${output} =~ ERROR ]]
}


@test "view ontology" {
	run sd_view_ontology
	[[ "$status" -eq 0 ]]
	echo "$output" > /tmp/x
	[[ ${lines[0]} =~ "<http://linkeddata.center/kees/v1>" ]]
	
	run sd_view_ontology -o ntriples
	[[ "$status" -eq 0 ]]
	[[ ${lines[0]} =~ "<http://linkeddata.center/kees/v1>" ]]
}


@test "view ontology -o turtle" {
	run sd_view_ontology -o turtle
	[[ "$status" -eq 0 ]]
	[[ ${lines[0]} =~ "@base <urn:sdaas:tbox> ." ]]
}



@test "view ontology -o rdfxml" {
	run sd_view_ontology -o rdfxml
	[[ "$status" -eq 0 ]]
	[[ ${lines[0]} =~ "<?xml version=\"1.0\" encoding=\"utf-8\"?>" ]]
}


@test "view version" {
	run sd_view_version
	[[ "$status" -eq 0 ]]
	[[ "${lines[0]}" == "$SDAAS_VERSION" ]]
}
