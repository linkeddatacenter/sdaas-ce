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
	#echo $output > /tmp/a
	[  $status -eq 0 ]
	[[ $output =~ "urn:graph:calculated_trusts,12" ]]
}
