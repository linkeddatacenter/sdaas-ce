![logo](http://linkeddata.center/resources/v4/logo/Logo-colori-trasp_oriz-640x220.png)

# Welcome to LinkedData.Center SDaaS Platform Community Edition (SDaaS-CE)

A platform to build knowledge graphs.
This is  vanilla open source implementation of the [LinkeData.Center SDaaS™ product](https://it.linkeddata.center/p/sdaas).
See documentation in [SDaaS wiki](https://bitbucket.org/linkeddatacenter/sdaas/wiki/Home).

Try a short [on-line demo of the platform](https://en.linkeddata.center/l/sdaas-ce-demo/).

## 🚀 Quickstart

```
docker build -t linkeddatacenter/sdaas-ce .
docker run --name sdmp -d -p 8080:8080 linkeddatacenter/sdaas-ce
```
browse knowledge base at http://localhost:8080/sdaas


To build a demo environment run:

	docker exec -t sdmp sdaas -f build.sdaas --reboot

when finished:

	docker rm -f sdmp

## Development environment ##

You need a gnu compliant system with following packages installed:

- bash (version > 4.4 )
- coreutils: base64 basename cat chgrp chmod chown cp cut date dir dirname echo env
  head md5sum mkdir mktemp mv pwd realpath rm rmdir sleep sort split stat tail tee test
  touch tr uniq unlink wc ...
- curl
- find
- awk
- grep
- sed

Start a standard development environment by executing in docker with the 
default bash distribution; then install the required packages:


```
docker run --rm -it -v "$(pwd):/workspace" -w /workspace bash
./alpinelinux_provisioning.sh
```


## smoke test ###

	./scripts/sdaas --no-warmup
	exit

## Unit tests ###

In order to run unit tests bats is needed (see https://github.com/bats-core/bats-core ):

```
apk --no-cache add bats
bats tests/unit/
exit
```


## Functional and system tests

To run functional and system tests you will need to start a local instance of blazegraph.
By default, test scripts expect blazegraph endpoint at http://localhost:8080/sdaas 
but you can configure a different address exporting the the SD_REASONER_ENDPOINT.
The instance of blazegraph must share /workspace volume with sdaas.

**WARNING**: blazegraph needs at least 2GB RAM to run functional tests.

The easy way, is to start from  the lyrasis/blazegraph blazegraph docker distribution 
and then installing inside its image the missing components:

```
docker run -d --name sdmp -v "$(pwd):/workspace" -p 8080:8080  lyrasis/blazegraph:2.1.5
docker exec -ti -w /workspace sdmp bash
./alpinelinux_provisioning.sh
apk --no-cache add bats
# ... access blazegraph workbench browsing http://localhost:8080/bigdata
```


For functional test execute: 

```
bats tests/functional
```

For system test, verify that the host is able to access Internet then  execute 

```
bats tests/system/platform
```

You can also launch directly the build process with:

```
cd tests/system/platform
../../../scripts/sdaas -f build.sdaas --reboot
```

To free the docker resources:

```
exit
docker rm -f sdmp 
```

Have a look also to the [developer wiki](https://github.com/linkeddatacenter/sdaas-ce/wiki)


## Push to docker hub

To push a new docker image to docker hub:

```
docker build -t linkeddatacenter/sdaas-ce .
docker login
# input the docker hub credentials...
docker tag linkeddatacenter/sdaas-ce linkeddatacenter/sdaas-ce:x.x.x
docker push linkeddatacenter/sdaas-ce
```


## Credits and license

The sdaas community edition platform is derived from [LinkedData.Center SDaas Product](https://it.linkeddata.center/p/sdaas) and licensed with MIT by LinkedData.Center

Copyright (C) 2018-2019 LinkedData.Center SRL
 - All Rights Reserved
Permission to copy and modify is granted under the [MIT license](LICENSE)

