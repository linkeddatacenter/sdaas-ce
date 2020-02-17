# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/). 

## [unreleased]

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
- rdf file accrual policy in reasoner
- tracing outputs of SD_REASONER_QUERY and SD_REASONER_UPDATE
- improved debug info

### Removed

- unused fourth paramether in SD_REASONER_QUERY
- unused third paramether in SD_REASONER_UPDATE
- rdf file accural policy in reasoner

### fixed

- SD_REASONER_UPDATE now exit on fatal error

### Changed

- aligned with sdaas-rdfstore 1.1.0
- rdf file accural policy in reasoner

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
- accrual policy to reasoner

## 2.1.0

First release, aligned with SDaaS [2.0.3] (Talete)


[Unreleased]:  https://github.com/linkeddatacenter/sdaas-ce/compare/2.5.0...HEAD
[2.5.0]:  https://github.com/linkeddatacenter/sdaas-ce/compare/2.4.0...2.5.0
[2.4.0]:  https://github.com/linkeddatacenter/sdaas-ce/compare/2.3.2...2.4.0
[2.3.2]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.3.1...2.3.2
[2.3.1]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.3.0...2.3.1
[2.3.0]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.2.1...2.3.0
[2.2.1]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.2.0...2.2.1
[2.2.0]: https://github.com/linkeddatacenter/sdaas-ce/compare/2.1.0...2.2.0
