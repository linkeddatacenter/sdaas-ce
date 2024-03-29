# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/). 

## [unreleased]


## [4.0.0]

Complete refactoring see https://gitlab.com/linkeddatacenter/sdaas/doc v.4.0.0 for project documentation

## [3.3.1]

### Fixed

- bug #19 (FAILCHECK mode does not work)
- references in change log

## [3.3.0]

### Fixed

- bug #16 (bad dateTime spelling)
- bug #15 (obsolete namespace for xsd)

### Changed

- aligned with new rdfStore (issue #17)
- changed the default SD_CACHE . Now is /tmp/sdaas (issue #13)
- prov plan message "calling axiom.." changed to "inferencing axiom.." (issue #7)
- more time to warmup (issue #9)

### Added

- Add support to select in testing ( #issue 14)
- issue #8 . Added a extra parameter to SD_DATA_TEST: if equal to "FASTFAIL" returns 1 on first test failed, if equal to "FAILCHECK" return 1 if one test failed
- added git, helm, yq, jq, unzip and csvtool support (issue #10)
- added shacl support enhancement (issue #11)

## [3.2.2]

### Fixed

- _SD_CURL_CMD return 1 for 2xx results
- SD_CREATE_REASONER and SD_DESTROY_REASONER

## [3.2.1]

### Fixed

- SD_QUEUE --> SD_CACHE in dockerfile
- tests in README.md

## [3.2.0]

### Added

- params to SD_CREATE_DATA_DISTRIBUTION

### Removed

- variables _SD_DIST_DIR and _SD_QUESTIONS_DIR in SD_CREATE_DATA_DISTRIBUTION
- readme in distand extra file copied

### Fixed:

- renamed __module_answering in __module_teaching

## [3.1.0]

### Added

- variables SD_UPLOAD_DIR, _SD_LOCAL_REASONER_STARTED, SDAAS_SIZE
- functions to bg_reasoning: SD_START_LOCAL_REASONING_ENGINE, SD_WARMUP_REASONING_ENGINE, SD_STOP_LOCAL_REASONING_ENGINE
- entrypoint script 

### Changed

- aligned with sdaas_rdfstore 2.1.1
- native local native kb implementation
- change implementation of bg_reasoning
- Swapped paramether in SD_REASONER_LOAD

### Removed

- service_registry
- SDAAS binary from PATH

### Fixed

- SD_NOWARMUP from environment now works
- typos in help and documentation

## [3.0.0]

bridge release

### changed

- version changed to 3 and name to "Anassimene"
- copyright header in some files
- aligned with sdaas_rdfstore 2.0.0
- OS moved from alpine to debian
- default user is jetty

### Removed

- alpinelinux_provisioning.sh script

## [2.5.0]

### added

- --no-warmup option and SD_NOWARMUP env variable support

### fixed

- missing SD_START_RULESET_ACTIVITY is ruleset when update
- bug in changelog history

## [2.4.0]

### added

- ruleset plugin
- testing plugin

### fixed

- missing "S" in _SD_QUESTIONS_DIR in teaching.include


### changed

- optimized ENV position in docker file

## [2.3.2]

### fixed

- debug messages
- error in moving files  from empty directory in _SD_TRANSFORM (SD_LEARNING)
- removed useless awk dependency in teaching

### changed

- optimized _SD_CURL_CMD (removed eval)

### added

- new sparql extension for sparql queries in SD_CREATE_DATA_DISTRIBUTION

## [2.3.1]

### changed

- optimized SD_LEARN when no transformations required
- optimized SD_LEARN when file loading is required
- optimized SD_INCLUDE
- SD_EVAL_CONSTRUCTOR creates metadata
- SD_REASONING_BY do nothing now.
- _SD_CURL_DOWNLOADER moved to _SD_CURL_CMD

### added

- created module curl_utils
- SD_EVAL_CONSTRUCTOR accept url as a constructor
- final consistency check


### removed

- _SD_CURL_POST

## [2.3.0]

### Added

- activity module
- full compatibility with KEES language profile
- SD_URISPACE,  SD_ACTIVITY_URI and _SD_ACTIVITY_STATUS variables support
- functional test improvements
- --urispace option

### fixed

- Let REASONER engine warmup at start

### changed

- new default downloader
- SD_HELP in SD_STATUS

## [2.2.1]

### Added

- shortcuts support in SD_REASONER_QUERY
- rdf file accrual method in reasoner
- tracing outputs of SD_REASONER_QUERY and SD_REASONER_UPDATE
- improved debug info

### Removed

- unused fourth paramether in SD_REASONER_QUERY
- unused third paramether in SD_REASONER_UPDATE
- rdf file accrual method in reasoner

### fixed

- SD_REASONER_UPDATE now exit on fatal error

### Changed

- aligned with sdaas-rdfstore 1.1.0
- rdf file accrual method in reasoner

## [2.2.0]

aligned with SDaaS [2.1.0] 

### Removed

- boilerplate removed (use tests/system/platform)

### Added

- test environments
- copyright notice on all scripts

### Changed

- refactory
- license conditions
- dockerfile file structure (now aligned to linkeddatacenter/sdaas-rdfstore:1.0.0)
- accrual method to reasoner

## 2.1.0

First release, aligned with SDaaS [2.0.3] (Talete)


[Unreleased]:  https://github.com/linkeddatacenter/sdaas-ce/compare/4.0.0...HEAD
[4.0.0]:  https://github.com/linkeddatacenter/sdaas-ce/compare/3.3.1...4.0.0
[3.3.1]:  https://github.com/linkeddatacenter/sdaas-ce/compare/3.3.1...3.3.0
[3.3.0]:  https://github.com/linkeddatacenter/sdaas-ce/compare/3.3.0...3.2.2
[3.2.2]:  https://github.com/linkeddatacenter/sdaas-ce/compare/3.2.2...3.1.1
[3.2.1]:  https://github.com/linkeddatacenter/sdaas-ce/compare/3.2.1...3.1.0
[3.2.0]:  https://github.com/linkeddatacenter/sdaas-ce/compare/3.2.0...3.1.0
[3.1.0]:  https://github.com/linkeddatacenter/sdaas-ce/compare/3.1.0...3.0.0
[3.0.0]:  https://github.com/linkeddatacenter/sdaas-ce/compare/2.5.0...3.0.0
[2.5.0]:  https://github.com/linkeddatacenter/sdaas-ce/compare/2.4.0...2.5.0
[2.4.0]:  https://github.com/linkeddatacenter/sdaas-ce/compare/2.3.2...2.4.0
[2.3.2]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.3.1...2.3.2
[2.3.1]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.3.0...2.3.1
[2.3.0]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.2.1...2.3.0
[2.2.1]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.2.0...2.2.1
[2.2.0]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.1.0...2.2.0
