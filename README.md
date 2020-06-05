![logo](http://linkeddata.center/resources/v4/logo/Logo-colori-trasp_oriz-640x220.png)

# Welcome to LinkedData.Center SDaaS Platform Community Edition (SDaaS-CE)

A platform to build knowledge graphs.
This is  vanilla open source implementation of the [LinkeData.Center SDaaS™ product](https://it.linkeddata.center/p/sdaas).
See documentation in [SDaaS wiki](https://bitbucket.org/linkeddatacenter/sdaas/wiki/Home).

Try a short [on-line demo of the platform](https://en.linkeddata.center/l/sdaas-ce-demo/).

## 🚀 Quickstart


	docker run --name sdmp -d -p 8080:8080 linkeddatacenter/sdaas-ce
	docker exec -t sdmp sdaas -f build.sdaas --reboot

browse knowledge base at http://localhost:8080/sdaas

when finished:

	docker rm -f sdmp

## Start test environment

*Note on windows user: to mount local volume from a git bash `export MSYS_NO_PATHCONV=1` [see this note](https://stackoverflow.com/questions/7250130/how-to-stop-mingw-and-msys-from-mangling-path-names-given-at-the-command-line#34386471)*

	docker build -t sdaas-dev -f Dockerfile.dev .
	docker run --name sdmp -d -p 8080:8080 -v ${PWD}:/workspace sdaas-dev
	docker exec -ti sdmp bash


## Smoke tests 

Test sdaas cli:

	sdaas --no-warmup
	exit
	
run a quick platform test:

	cd tests/system/platform 
	sdaas sdaas -f build.sdaas --reboot
	cd ../../..

point a browser to http://localhost:8080/sdaas/#query  and execute:

	SELECT (COUNT(?s) AS ?edges) WHERE{?s?p?o}

You shoud get about 24544 edges

## Unit tests

In order to run unit tests bats is needed (see https://github.com/bats-core/bats-core ):

	bats tests/unit/


## Functional tests

To run functional and system tests you will need the local instance of blazegraph.
By default, test scripts expect blazegraph endpoint at http://localhost:8080/sdaas 
but you can configure a different address exporting the the SD_REASONER_ENDPOINT.
The instance of blazegraph must share /workspace volume with sdaas.

**WARNING**: blazegraph needs at least 2GB RAM to run functional tests.

For functional test execute: 

	bats tests/functional

## System tests

For system test, verify that the host is able to access Internet then  execute 

	bats tests/system/platform


## Free test environment

To free the docker resources:

	exit
	docker rm -f sdmp 


Have a look also to the [developer wiki](https://github.com/linkeddatacenter/sdaas-ce/wiki)


## Push to docker hub

To push a new docker image to docker hub:


	docker build -t linkeddatacenter/sdaas-ce .
	docker login
	# input the docker hub credentials...
	docker tag linkeddatacenter/sdaas-ce linkeddatacenter/sdaas-ce:x.x.x
	docker push linkeddatacenter/sdaas-ce



## Credits and license

The sdaas community edition platform is derived from [LinkedData.Center SDaas Product](https://it.linkeddata.center/p/sdaas) and licensed with MIT by LinkedData.Center

Copyright (C) 2018-2019 LinkedData.Center SRL
 - All Rights Reserved
Permission to copy and modify is granted under the [MIT license](LICENSE)

