![logo](http://linkeddata.center/resources/v4/logo/Logo-colori-trasp_oriz-640x220.png)

# Welcome to LinkedData.Center SDaaS Platform Community Edition (SDaaS-CE)

A platform to build knowledge graphs.

This is an open source implementation of the [LinkeData.Center SDaaS™ product](https://it.linkeddata.center/p/sdaas).
See documentation in [SDaaS wiki](https://bitbucket.org/linkeddatacenter/sdaas/wiki/Home).

The SDaaS requires [docker](https://www.docker.com/) 

This implementation embeds a sdaas-rdfstore based on blazegraph.



> ## End of Support approaching
>
> Starting from the major release of version 4 of SDaaS Enterprise Edition, planned for 2024 Q1,
> The Community Edition will no longer be actively developed by LinkedData.Center.
>
> If you plan to use SDaaS for professional use, please consider moving to Enterprise Edition.
> Contact https://LinkedData.Center for more info, prices, support and documentation.
> 
> This repository will continue to exists and maintained and support from community is welcome
>
> As always, documentation, support, and training for SDaaS Community Edition will continue to be available by LinkedData.Center as professional services.

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


	docker build -t sdaas .


**Smoke tests:** 

Manually start sdaas cli without the local reasoner 

```
docker run --name sdmp --rm -ti -v ${PWD}:/workspace --entrypoint bash sdaas
git --version
jq --version
yq --version
gettext --version
command -v csvtool
command -v shaclvalidate.sh
scripts/sdaas
exit
```


**Unit tests:**

In order to run unit tests bats is needed (see https://github.com/bats-core/bats-core ):

	bats tests/unit/
	

**Functional tests:**

To run functional and system tests you will need the local instance of blazegraph.
By default, test scripts expect blazegraph endpoint at http://localhost:8080/sdaas 
but you can configure a different address exporting the the SD_SPARQL_ENDPOINT.
The instance of blazegraph must share /workspace volume with sdaas.


For functional test execute: 

```
/sdaas-start -d  #start embedded graph engine in background
bats tests/functional
```

**System tests:**

For system test, verify that the host is able to access Internet then  execute 

```
bats tests/system/platform
scripts/sdaas
SD_SPARQL_QUERY csv "SELECT (COUNT(?s) AS ?edges) WHERE{?s?p?o}"
curl -d ESTCARD http://localhost:8080/sdaas/sparql
# in both case you should >  31K triples 
SD_SPARQL_UPDATE "DROP ALL"
exit
```

To free the docker resources:

	exit


Have a look also to the [developer wiki](https://github.com/linkeddatacenter/sdaas-ce/wiki)


## Push to docker hub

To push a new docker image to docker hub:

```
docker login
# input the docker hub credentials...
docker build -t linkeddatacenter/sdaas-ce .
docker tag linkeddatacenter/sdaas-ce linkeddatacenter/sdaas-ce:3.3.1
docker push linkeddatacenter/sdaas-ce
docker push linkeddatacenter/sdaas-ce:3.3.1
```


## Credits and license

The sdaas community edition platform is derived from [LinkedData.Center SDaas Product](https://it.linkeddata.center/p/sdaas) and licensed with MIT by LinkedData.Center

Copyright (C) 2018-2021 LinkedData.Center SRL
 - All Rights Reserved
Permission to copy and modify is granted under the [MIT license](LICENSE)

