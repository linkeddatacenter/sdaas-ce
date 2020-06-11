#!/usr/bin/env bats

function doTest {
    rm -rf "/tmp/distrib"
    cd $BATS_TEST_DIRNAME
    ../../../scripts/sdaas -f build.sdaas --reboot
    cat /tmp/distrib/triplecounts.csv
 }


@test "Ingestion platform acceptance test..." {
	run doTest
	[  $status -eq 0 ]
	#echo "$output" > /tmp/x
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
	[[ "${lines[14]}" =~ "transformation pipeline: in/* -> cat -> iconv -f ISO88592 -t UTF-8|tr -d '\r' | awk -f gateways/istat.awk -> out"  ]]
	[[ "${lines[15]}" =~ "completed by replacing graph <urn:graph:istat>"  ]]
	[[ "${lines[16]}" =~ "starded reasoning on graph <urn:graph:trustmap_default>"  ]]
	[[ "${lines[17]}" =~ "evaluating axiom @axioms/default_trustmap.construct..."  ]]
	[[ "${lines[18]}" =~ "completed by replacing graph <urn:graph:trustmap_default>"  ]]
	[[ "${lines[19]}" =~ "starded reasoning on graph <urn:graph:calculated_trusts>"  ]]
	[[ "${lines[20]}" =~ "evaluating axiom @axioms/calculated_trusts.construct..."  ]]
	[[ "${lines[21]}" =~ "completed by replacing graph <urn:graph:calculated_trusts>"  ]]
	[[ "${lines[22]}" =~ "Copying documentation file questions/README.md"  ]]
	[[ "${lines[23]}" =~ "Generating answers for triplecounts tabular question"  ]]
	[[ "${lines[24]}" =~ "Distribution completed in /tmp/distrib"  ]]
	[[ "${lines[25]}" =~ "Testing knowledge graph integrity..."  ]]
	[[ "${lines[26]}" =~ "1_istat_exists.ask...OK"  ]]
	[[ "${lines[27]}" =~ "Knowledge ingestion succesfully completed"  ]]
	[[ "${lines[28]}" =~ "graphName,RDF_statements"  ]]
	[[ "${lines[29]}" =~ "urn:graph:istat,15981"  ]]
	[[ "${lines[30]}" =~ "http://schema.org/,8472"  ]]
	[[ "${lines[31]}" =~ "urn:kees:config,55"  ]]
	[[ "${lines[32]}" =~ "urn:graph:calculated_trusts,23"  ]]
	[[ "${lines[33]}" =~ "urn:graph:trustmap_default,13"  ]]
}
