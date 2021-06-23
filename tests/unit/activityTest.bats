#!/usr/bin/env bats

function SD_LOAD_RDF_FILE { : ; }

function setup {
	for stub in asserting caching date curl; do
		. "$BATS_TEST_DIRNAME/stubs/${stub}_stub.include"
	done
	SD_INCLUDE logging
	SD_INCLUDE activity
	CREATE_STUB_CACHE
	mkdir -p "$SD_CACHE/activity.test"
}

function teardown {
	if [  $SD_DEBUG -eq 0 ]; then DROP_STUB_CACHE ; fi
}


@test "_SD_START_ACTIVITY" {
	_SD_ACTIVITY_STATUS="noop"
	SD_URISPACE="urn:"
	_SD_START_ACTIVITY "commento esplicito" "$SD_CACHE/activity.test"
	[ -d "$SD_ACTIVITY_DIR" ]
	[ -d "$SD_ACTIVITY_DIR/in" ]	
	[ -f "$SD_ACTIVITY_DIR/prov.ttl" ]
	[ ! -z "$SD_ACTIVITY_URI" ]
    [ "$_SD_ACTIVITY_STATUS" = "running" ]
    #>&2 cat /tmp/stub_cache/activity.test/prov.ttl
	run cat "$SD_ACTIVITY_DIR/prov.ttl"
	[ "${lines[0]}"  = "@prefix : <urn:activity.test_> ." ]
	[ "${lines[1]}"  = "@prefix prov: <http://www.w3.org/ns/prov#> ." ]
	[ "${lines[2]}"  = "@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> ." ]
	[ "${lines[3]}"  = "@prefix xsd: <http://www.w3.org/2001/XMLSchema#> ." ]	
	[ "${lines[4]}"  = "@prefix dct: <http://purl.org/dc/terms/> ." ]
	[ "${lines[5]}"  = "@prefix sd: <http://www.w3.org/ns/sparql-service-description#> ." ]
	[ "${lines[6]}"  = "@prefix kees: <http://linkeddata.center/kees/v1#> ." ]	
	[ "${lines[7]}"  = ":activity a prov:Activity;" ]
	[ "${lines[8]}"  = "    prov:qualifiedAssociation :activity_owner." ]
	[ "${lines[9]}"  = ":activity_owner a prov:Association ;" ]
	[ "${lines[10]}" = "    prov:agent <https://linkeddata.center/agent/anassimene#me> ;" ]
	[ "${lines[11]}" = "    prov:hadRole kees:namedGraphGenerator ;" ]
	[ "${lines[12]}" = "    prov:hadPlan \"\"\"commento esplicito\"\"\"." ]
	[ "${lines[13]}" = ":activity prov:startedAtTime \"Sun Dec 24 00:00:00 UTC 2017\"^^xsd:dateTime ." ]
}

