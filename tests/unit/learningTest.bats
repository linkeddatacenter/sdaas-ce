#!/usr/bin/env bats

function SD_LOAD_RDF_FILE { : ; }

function setup {
	for stub in asserting caching date curl; do
		. "$BATS_TEST_DIRNAME/stubs/${stub}_stub.include"
	done
	SD_INCLUDE logging
	SD_INCLUDE learning
	CREATE_STUB_CACHE
	mkdir -p "$SD_CACHE/activity.test"
	dd if=/dev/zero of=/tmp/file1.ttl  bs=10K  count=1 > /dev/null 2>&1
	dd if=/dev/zero of=/tmp/file2.ttl  bs=10K  count=1 > /dev/null 2>&1
}

function teardown {
	if [  $SD_DEBUG -eq 0 ]; then DROP_STUB_CACHE ; fi
	rm -f /tmp/file1.ttl /tmp/file2.ttl
}



function _prov {
	>&2 echo "------PROV-----"
	>&2 cat /tmp/stub_cache/activity.test/prov.ttl
	>&2 echo "---------------"
}


@test "_SD_START_ACTIVITY" {
	_SD_START_ACTIVITY "commento esplicito" "$SD_CACHE/activity.test"
	[ -d "$SD_ACTIVITY_DIR" ]
	[ -d "$SD_ACTIVITY_DIR/in" ]	
	[ -f "$SD_ACTIVITY_DIR/prov.ttl" ]
	run cat "$SD_ACTIVITY_DIR/prov.ttl"
	[ "${lines[0]}" = "@base <file://localhost${SD_ACTIVITY_DIR}/> ." ]
	[ "${lines[1]}" = "@prefix : <prov.ttl#> ." ]
	[ "${lines[2]}" = "@prefix prov: <http://www.w3.org/ns/prov#> ." ]
	[ "${lines[3]}" = "@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> ." ]
	[ "${lines[4]}" = "@prefix xsd: <http://www.w3.org/2000/10/XMLSchema#> ." ]
	[ "${lines[5]}" = ':learn a prov:Activity; prov:startedAtTime "Sun Dec 24 00:00:00 UTC 2017"^^xsd:datetime;rdfs:comment """commento esplicito""" .' ]
}


function DOWNLOADER_STUB { 
	echo "empty content"
}

@test "_SD_EXTRACT" {
	SD_DEFAULT_DOWNLOADER=DOWNLOADER_STUB
	_SD_SOURCES=("$BATS_TEST_DIRNAME/data/two_triples.nt" "$BATS_TEST_DIRNAME/data/two_triples.ttl" "http://example.com/data|.rdf|other content|echo")
	_SD_START_ACTIVITY "commento esplicito" "$SD_CACHE/activity.test"
	
	filename1=$(_SD_MK_UID "file://localhost${BATS_TEST_DIRNAME}/data/two_triples.nt")
	filename2=$(_SD_MK_UID "file://localhost${BATS_TEST_DIRNAME}/data/two_triples.ttl")
	filename3=$(_SD_MK_UID "http://example.com/data")
	run _SD_EXTRACT
	[ $status -eq 0 ]
	[ "${lines[0]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity.test downloaded file://localhost${BATS_TEST_DIRNAME}/data/two_triples.nt" ]
	[ "${lines[1]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity.test downloaded file://localhost${BATS_TEST_DIRNAME}/data/two_triples.ttl" ]
	[ "${lines[2]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity.test downloaded http://example.com/data" ]
	[ -f "${SD_ACTIVITY_DIR}/in/$filename1.nt" ]
	[ -f "${SD_ACTIVITY_DIR}/in/$filename2.ttl" ]
	[ -f "${SD_ACTIVITY_DIR}/in/$filename3.rdf" ]
	
	run cat "$SD_ACTIVITY_DIR/in/$filename1.nt"
	[ $status -eq 0 ]
	[ "$output" = "empty content" ]
	
	run cat "$SD_ACTIVITY_DIR/in/$filename3.rdf"
	[ $status -eq 0 ]
	[ "$output" = "http://example.com/data other content" ]
	
	run cat "$SD_ACTIVITY_DIR/prov.ttl"
	[ $status -eq 0 ]
	[ "${lines[6]}" = ':learn prov:wasInfluencedBy :extraction. :extraction a prov:Activity; prov:startedAtTime "Sun Dec 24 00:00:00 UTC 2017"^^xsd:datetime .' ]
	[ "${lines[7]}" = ":learn prov:used <file://localhost${BATS_TEST_DIRNAME}/data/two_triples.nt> . :extraction prov:generated <in/$filename1.nt> ." ]
	[ "${lines[8]}" = ":learn prov:used <file://localhost${BATS_TEST_DIRNAME}/data/two_triples.ttl> . :extraction prov:generated <in/$filename2.ttl> ." ]
	[ "${lines[9]}" = ":learn prov:used <http://example.com/data> . :extraction prov:generated <in/$filename3.rdf> ." ]
	[ "${lines[10]}" = ':extraction prov:endedAtTime "Sun Dec 24 00:00:00 UTC 2017"^^xsd:datetime .' ]
}



function TRANSFORMER_STUB { 
	echo "$@"
}


@test "_SD_TRANSFORM" {
	_SD_START_ACTIVITY "commento esplicito" "$SD_CACHE/activity.test"
	
	# simulate two zipped file in input queue
	cat $BATS_TEST_DIRNAME/data/two_triples.nt | gzip -c > $SD_ACTIVITY_DIR/in/file1.nt.gz
	cat $BATS_TEST_DIRNAME/data/two_triples.ttl | gzip -c > $SD_ACTIVITY_DIR/in/file2.ttl.gz
	cp  $BATS_TEST_DIRNAME/data/simple.csv $SD_ACTIVITY_DIR/in/file3.csv
	
	_SD_TRANSFORMATIONS=('zcat|in/*.gz|unzipped' 'cat|unzipped|out|.rdf|' 'cat|in/*.csv|cutted|keep|tail -n +2' "cat|cutted|out|keep|tr -d 'Y'")
	# Same as: 
	#_SD_TRANSFORMATIONS=('zcat|in/*.gz|unzipped||cat' 'cat|unzipped|out|.rdf|cat' 'cat|in/*.csv|out|keep|tr -d \'Y\' | tail -n +2')
	
	run _SD_TRANSFORM
	[ $status -eq 0 ]
	[ "${lines[0]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity.test files in 'in/*.gz' have been processed with 'cat'. The results were placed in 'unzipped'." ]
	[ "${lines[1]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity.test files in 'unzipped/*' have been processed with 'cat'. The results were placed in 'out'." ]
	[ "${lines[2]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity.test files in 'in/*.csv' have been processed with 'tail -n +2'. The results were placed in 'cutted'." ]
	[ "${lines[3]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity.test files in 'cutted/*' have been processed with 'tr -d 'Y''. The results were placed in 'out'." ]
	run cat "$SD_ACTIVITY_DIR/prov.ttl"
	[ $status -eq 0 ]
	[ "${lines[6]}" = ':learn prov:wasInfluencedBy :transformation. :transformation a prov:Activity; prov:wasInformedBy :extraction; prov:startedAtTime "Sun Dec 24 00:00:00 UTC 2017"^^xsd:datetime .' ]
	[ "${lines[7]}" = ':transformation prov:used <in/file1.nt.gz)>; prov:generated <unzipped/file1.nt> .' ]
	[ "${lines[8]}" = ':transformation prov:used <in/file2.ttl.gz)>; prov:generated <unzipped/file2.ttl> .' ]
	[ "${lines[9]}" = ':transformation prov:used <unzipped/file1.nt)>; prov:generated <out/file1.rdf> .' ]
	[ "${lines[10]}" = ':transformation prov:used <unzipped/file2.ttl)>; prov:generated <out/file2.rdf> .' ]
	[ "${lines[11]}" = ':transformation prov:used <in/file3.csv)>; prov:generated <cutted/file3.csv> .' ]
	[ "${lines[12]}" = ':transformation prov:used <cutted/file3.csv)>; prov:generated <out/file3.csv> .' ]
	[ "${lines[13]}" = ':transformation prov:endedAtTime "Sun Dec 24 00:00:00 UTC 2017"^^xsd:datetime .' ]
}

