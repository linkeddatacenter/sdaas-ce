# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [unreleased]

### changed

- optimized SD_LEARN when no transformations required
- optimized SD_LEARN when file loading is required
- optimized SD_INCLUDE

### added

- module curl_utils

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


[Unreleased]: https://bitbucket.org/linkeddatacenter/sdaas/compare/master%0D2.3.0
[2.3.0]: https://bitbucket.org/linkeddatacenter/sdaas/compare/2.3.0%0D2.2.1
[2.2.1]: https://bitbucket.org/linkeddatacenter/sdaas/compare/2.2.1%0D2.2.0
[2.2.0]: https://bitbucket.org/linkeddatacenter/sdaas/compare/2.2.0%0D2.1.0
