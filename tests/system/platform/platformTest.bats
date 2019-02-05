#!/usr/bin/env bats

function doTest {
    export _SD_DIST_DIR=/tmp/distrib
    rm -rf "/tmp/distrib"
    cd $BATS_TEST_DIRNAME
    ../../../scripts/sdaas -f build.sdaas --reboot
    cat $_SD_DIST_DIR/triplecounts.csv
 }


@test "Ingestion platform acceptance test..." {
	run doTest
	[  $status -eq 0 ]
	# echo "$output" > /tmp/x
	[[ "${lines[0]}"  =~ "SD_START_LOGGING logging"  ]]
	[[ "${lines[1]}"  =~ "SD_START_LOGGING debug info in .cache/session_"  ]]
	[[ "${lines[2]}"  =~ "LinkedData.Center SDaaS platform (Anassimene) using 'kb' graph technology."  ]]
	[[ "${lines[3]}"  =~ "Erasing the knowledge base... (it could take a while)"  ]]
	[[ "${lines[4]}"  =~ "starded learning of graph <urn:kees:config>"  ]]
	[[ "${lines[5]}"  =~ "downloaded data/kees.ttl"  ]]
	[[ "${lines[6]}"  =~ "downloaded data/introspection.ttl"  ]]
	[[ "${lines[7]}"  =~ "downloaded data/trustmap.ttl"  ]]
	[[ "${lines[8]}"  =~ "completed by replacing graph <urn:kees:config>"  ]]
	[[ "${lines[9]}"  =~ "starded learning of graph <http://schema.org/>"  ]]
	[[ "${lines[10]}" =~ "downloaded http://schema.org/version/3.4/schema.ttl"  ]]
	[[ "${lines[11]}" =~ "completed by replacing graph <http://schema.org/>"  ]]
	[[ "${lines[12]}" =~ "starded learning of graph <urn:graph:istat>"  ]]
	[[ "${lines[13]}" =~ "downloaded https://s3-eu-west-1.amazonaws.com/demo.hub1.linkeddata.center/data/comuni.csv"  ]]
	[[ "${lines[14]}" =~ "files in 'in/*' processed with 'iconv -f ISO88592  -t UTF-8|tr -d '\r'|gateways/istat'. Results sent to 'out'"  ]]
	[[ "${lines[15]}" =~ "completed by replacing graph <urn:graph:istat>"  ]]
	[[ "${lines[16]}" =~ "starded reasoning on graph <urn:graph:trustmap_default>"  ]]
	[[ "${lines[17]}" =~ "evaluating axiom @axioms/default_trustmap.construct..."  ]]
	[[ "${lines[18]}" =~ "completed by replacing graph <urn:graph:trustmap_default>"  ]]
	[[ "${lines[19]}" =~ "starded reasoning on graph <urn:graph:calculated_trusts>"  ]]
	[[ "${lines[20]}" =~ "evaluating axiom @axioms/calculated_trusts.construct..."  ]]
	[[ "${lines[21]}" =~ "completed by replacing graph <urn:graph:calculated_trusts>"  ]]
	[[ "${lines[22]}" =~ "Copying questions/README.md"  ]]
	[[ "${lines[23]}" =~ "Generating answers for triplecounts tabular question"  ]]
	[[ "${lines[24]}" =~ "Distribution completed"  ]]
	[[ "${lines[25]}" =~ "Knowledge ingestion succesfully completed"  ]]
	[[ "${lines[26]}" =~ "graphName,RDF_statements"  ]]
	[[ "${lines[27]}" =~ "urn:graph:istat,15981"  ]]
	[[ "${lines[28]}" =~ "http://schema.org/,8472"  ]]
	[[ "${lines[29]}" =~ "urn:kees:config,109"  ]]
	[[ "${lines[30]}" =~ "urn:graph:calculated_trusts,25"  ]]
	[[ "${lines[31]}" =~ "urn:graph:trustmap_default,13"  ]]
}
