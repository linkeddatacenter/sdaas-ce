![logo](http://linkeddata.center/resources/v4/logo/Logo-colori-trasp_oriz-640x220.png)

# Welcome to LinkedData.Center SDaaS Platform Community Edition (SDaaS-CE)

A platform to build knowledge graphs.

This is an open source implementation of the [LinkeData.Center SDaaS™ product](https://it.linkeddata.center/p/sdaas).
See documentation in [SDaaS wiki](https://bitbucket.org/linkeddatacenter/sdaas/wiki/Home).

The SDaaS requires [docker](https://www.docker.com/) 

This implementation embeds a sdaas-rdfstore based on blazegraph.

Try a short [on-line demo of the platform](https://en.linkeddata.center/l/sdaas-ce-demo/).

## 🚀 Quickstart

This command will start a sdaas platform attached to an internal rdfstore with a micro memory foorprint

	docker run --rm -ti -p 8080:8080 linkeddatacenter/sdaas-ce --reboot

browse local reasoner at http://localhost:8080/sdaas type `exit` to leave the platform.

This command is the same as the previous but does not expose the workbench and uses a small memory foorprint

	docker run --rm -ti -e SDAAS_SIZE=small linkeddatacenter/sdaas-ce


To run sdaas platform withouth the local rdfstore 

	docker run --rm -ti -e SD_NOWARMUP=1 linkeddatacenter/sdaas-ce
	
Use this command to start and stop by hand a local micro rdfstore:

	SD_START_LOCAL_REASONING_ENGINE # you can specify the required memory footprint, default=micro
	SD_STOP_LOCAL_REASONING_ENGINE


## Start test environment

** build local image:**


	docker build -t sdaas  .


**Smoke tests:** 

*Note on windows user: to mount local volume from a git bash `export MSYS_NO_PATHCONV=1` [see this note](https://stackoverflow.com/questions/7250130/how-to-stop-mingw-and-msys-from-mangling-path-names-given-at-the-command-line#34386471)*

Manually start sdaas cli without the local reasoner 

	docker run --name sdmp --rm -ti -v ${PWD}:/workspace --entrypoint bash sdaas
	scripts/sdaas --no-warmup
	exit


**Unit tests:**

In order to run unit tests bats is needed (see https://github.com/bats-core/bats-core ):

	bats tests/unit/
	

**Functional tests:**

To run functional and system tests you will need the local instance of blazegraph.
By default, test scripts expect blazegraph endpoint at http://localhost:8080/sdaas 
but you can configure a different address exporting the the SD_SPARQL_ENDPOINT.
The instance of blazegraph must share /workspace volume with sdaas.


For functional test execute: 

	/sdaas-start -d  #start embedded graph engine in background
	bats tests/functional

**System tests:**

For system test, verify that the host is able to access Internet then  execute 

	bats tests/system/platform
	scripts/sdaas
	SD_SPARQL_QUERY csv "SELECT (COUNT(?s) AS ?edges) WHERE{?s?p?o}"
	SD_SPARQL_UPDATE "DROP ALL"
	exit


To free the docker resources:

	exit


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

Copyright (C) 2018-2020 LinkedData.Center SRL
 - All Rights Reserved
Permission to copy and modify is granted under the [MIT license](LICENSE)

