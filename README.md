![logo](http://linkeddata.center/resources/v4/logo/Logo-colori-trasp_oriz-640x220.png)

# Welcome to LinkedData.Center SDaaS Platform Community Edition (SDaaS-CE)

A platform to build knowledge graphs.

This is the open source distribution of the [LinkeData.Center SDaaS™ product](https://en.linkeddata.center/p/sdaas).


## 🚀 Quickstart

```
docker compose up -d --build
docker compose exec cli sdaas bats tests/{unit,functional,system}
docker compose down
```


## Installation & usage
See the [documentation](https://linkeddata.center/sdaas) for more info.


## Start test environment

**setup a vpn and run a graph store:**

To run functional and system tests you will need the local instance of blazegraph running in the same network of SDaaS.
By default, test scripts expect blazegraph endpoint at http://kb:8080/sdaas. 

```
docker network create myvpn
docker run --network myvpn --name kb -d linkeddatacenter/sdaas-rdfstore
```

**build and run local image:**

```
docker build -t linkeddatacenter/sdaas-ce .
docker run --rm -ti --network=myvpn -v "${PWD}":/workspace linkeddatacenter/sdaas-ce
```

**Unit tests:**

In order to run unit tests bats is used (see https://github.com/bats-core/bats-core ):

```
bats tests/unit/
```

**Functional tests:**


For functional tests, execute: 

```
bats tests/functional
```

**System tests:**

For system tests, verify that the host can access the Internet then execute:

```
bats tests/system
```

To free the docker resources:

```
exit
docker rm -f kb
docker network rm myvpn
```



## Push to docker hub

To push a new docker image to docker hub:
```
# docker login
# docker buildx create --name multi-arch-builder

NAME="linkeddatacenter/sdaas-ce" MAJOR="4" MINOR="2" PATCH="1"
docker buildx build --builder multi-arch-builder  --platform linux/arm64,linux/amd64 --build-arg MODE=prod --push -t $NAME:$MAJOR.$MINOR.$PATCH .
```

To compile images with docker cloud network use `--builder cloud-linkeddatacenter-sdaas` ( create the driver with `docker buildx create --driver cloud linkeddatacenter/sdaas` )


## Credits and license

The sdaas community edition platform is derived from [LinkedData.Center SDaas Product](https://en.linkeddata.center/p/sdaas) and licensed with MIT by LinkedData.Center.

Copyright (C) 2018-2024 LinkedData.Center SRL
 - All Rights Reserved
Permission to copy and modify is granted under the [MIT license](LICENSE)

