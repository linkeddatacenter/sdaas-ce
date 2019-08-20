#!/usr/bin/env bats

function SD_LOAD_RDF_FILE { : ; }

function DOWNLOADER_STUB { : ; }

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


@test "_SD_EXTRACT" {
	SD_DEFAULT_DOWNLOADER=DOWNLOADER_STUB
	_SD_START_ACTIVITY "commento esplicito" "$SD_CACHE/activity.test"
	
	filename1=$(_SD_MK_UID "${BATS_TEST_DIRNAME}/data/two_triples.nt")
	filename2=$(_SD_MK_UID "${BATS_TEST_DIRNAME}/data/two_triples.ttl")
	filename3=$(_SD_MK_UID "http://example.com/data")
	_SD_SOURCES=("$BATS_TEST_DIRNAME/data/two_triples.nt" "$BATS_TEST_DIRNAME/data/two_triples.ttl" "http://example.com/data|.rdf|other content|echo")
	run _SD_EXTRACT
	[ $status -eq 0 ]
	[ "${lines[0]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity activity.test downloaded ${BATS_TEST_DIRNAME}/data/two_triples.nt" ]
	[ "${lines[1]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity activity.test downloaded ${BATS_TEST_DIRNAME}/data/two_triples.ttl" ]
	[ "${lines[3]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity activity.test downloaded http://example.com/data" ]
	
	run cat "$SD_ACTIVITY_DIR/prov.ttl"
	[ $status -eq 0 ]
	[ "${lines[14]}" = ':activity prov:wasInfluencedBy :extraction. :extraction a prov:Activity; prov:startedAtTime "Sun Dec 24 00:00:00 UTC 2017"^^xsd:datetime .' ]
	[ "${lines[15]}" = ":extraction prov:generated <urn:sdaas:cache:activity.test:in/$filename1.nt> ." ]
	[ "${lines[16]}" = ":extraction prov:generated <urn:sdaas:cache:activity.test:in/$filename2.ttl> ." ]
	[ "${lines[17]}" = ":extraction prov:generated <urn:sdaas:cache:activity.test:in/$filename3.rdf> ." ]
	[ "${lines[18]}" = ':extraction prov:endedAtTime "Sun Dec 24 00:00:00 UTC 2017"^^xsd:datetime .' ]
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
	#echo "$output" > /tmp/x
	[ "${lines[0]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity activity.test transformation pipeline: in/*.gz -> zcat -> cat -> unzipped" ]
	[ "${lines[1]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity activity.test transformation pipeline: unzipped/* -> cat -> cat -> out" ]
	[ "${lines[2]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity activity.test transformation pipeline: in/*.csv -> cat -> tail -n +2 -> cutted" ]
	[ "${lines[3]}" = "sdaas Sun Dec 24 00:00:00 UTC 2017 - activity activity.test transformation pipeline: cutted/* -> cat -> tr -d 'Y' -> out" ]
	run cat "$SD_ACTIVITY_DIR/prov.ttl"
	#cp "$SD_ACTIVITY_DIR/prov.ttl" /tmp/x
	[ $status -eq 0 ]
	[ "${lines[14]}" = ':activity prov:wasInfluencedBy :transformation. :transformation a prov:Activity; prov:wasInformedBy :extraction; prov:startedAtTime "Sun Dec 24 00:00:00 UTC 2017"^^xsd:datetime .' ]
	[ "${lines[15]}" = ':transformation prov:used <urn:sdaas:cache:activity.test:in/file1.nt.gz)>; prov:generated <urn:sdaas:cache:activity.test:unzipped/file1.nt> .' ]
	[ "${lines[16]}" = ':transformation prov:used <urn:sdaas:cache:activity.test:in/file2.ttl.gz)>; prov:generated <urn:sdaas:cache:activity.test:unzipped/file2.ttl> .' ]
	[ "${lines[17]}" = ':transformation prov:used <urn:sdaas:cache:activity.test:unzipped/file1.nt)>; prov:generated <urn:sdaas:cache:activity.test:out/file1.rdf> .' ]
	[ "${lines[18]}" = ':transformation prov:used <urn:sdaas:cache:activity.test:unzipped/file2.ttl)>; prov:generated <urn:sdaas:cache:activity.test:out/file2.rdf> .' ]
	[ "${lines[19]}" = ':transformation prov:used <urn:sdaas:cache:activity.test:in/file3.csv)>; prov:generated <urn:sdaas:cache:activity.test:cutted/file3.csv> .' ]
	[ "${lines[20]}" = ':transformation prov:used <urn:sdaas:cache:activity.test:cutted/file3.csv)>; prov:generated <urn:sdaas:cache:activity.test:out/file3.csv> .' ]
	[ "${lines[21]}" = ':transformation prov:endedAtTime "Sun Dec 24 00:00:00 UTC 2017"^^xsd:datetime .' ]
}

