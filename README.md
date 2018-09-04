# sdaas-ce
A  docker with a lightweight implementation of a  [Smart Data Management Platform](https://it.linkeddata.center/b/smart-data-platform/) derived from the [LinkeData.Center SDaaS product](https://it.linkeddata.center//p/sdaas).

See  [LinkedData.Center SDaaS wiki](https://bitbucket.org/linkeddatacenter/sdaas/wiki/Home)

## Quickstart

```
docker run --name sdaas -d -p 8889:8080 -v $PWD/boilerplate:/workspace linkeddatacenter/sdaas-ce
docker exec -t sdaas -f build.sdaas --reboot
curl "http://localhost:8889/sdaas/sparql?query=SELECT DISTINCT ?g WHERE {GRAPH ?g {?s ?p ?o}}"
```

## Local builds

```
docker build -t sdaas-ce .
docker run --name sdaas -d -p 8889:8080 -v $PWD/boilerplate:/workspace sdaas-ce
docker exec -t sdaas -f build.sdaas --reboot
curl "http://localhost:8889/sdaas/sparql?query=SELECT DISTINCT ?g WHERE {GRAPH ?g {?s ?p ?o}}"
```

Navigate the knowledge base pointing a browser to http://localhost:9999/:


## Credits and license

- the dockerfile was inspired from [Docker Blazegraph](https://github.com/lyrasis/docker-blazegraph)
- the sdaas community edition platform is derived from [LinkedData.Center SDaas Product](https://it.linkeddata.center/p/sdaas) and licensed with MIT by LinkedData.Center to g0v community

