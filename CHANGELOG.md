# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.3] - 2023-09-28

### Changed in 1.3.3

- In `Dockerfile`, updated FROM instruction to `debian:11.7-slim@sha256:c618be84fc82aa8ba203abbb07218410b0f5b3c7cb6b4e7248fda7785d4f9946`

## [1.3.2] - 2023-04-04

### Changed in 1.3.2

- In `Dockerfile`, updated FROM instruction to `debian:11.6-slim@sha256:7acda01e55b086181a6fa596941503648e423091ca563258e2c1657d140355b1`
- Changed default `SENZING_DATA_VERSION` to `4.0.0`

## [1.3.1] - 2022-09-29

### Changed in 1.3.1

- In `Dockerfile`, updated FROM instruction to `debian:11.5-slim@sha256:5cf1d98cd0805951484f33b34c1ab25aac7007bb41c8b9901d97e4be3cf3ab04`

## [1.3.0] - 2022-05-09

### Changed in 1.3.0

- Moved from `data/2.0.0` to `data/3.0.0` as build arg default

## [1.2.1] - 2022-05-04

### Changed in 1.2.1

- Last release supporting senzingdata-v2.

## [1.2.0] - 2022-05-02

### Added to 1.2.0

- Support for msodbcsql17
- Support for `/etc/opt/senzing`
- Support for `senzing_governor.py`

## [1.1.0] - 2022-03-30

### Added to 1.1.0

- Support for staging

## [1.0.3] - 2022-03-04

### Changed in 1.0.3

- Changed `--archive` to `--recursive`

## [1.0.2] - 2022-02-09

### Changed in 1.0.2

- Update to Debian 11.2

## [1.0.1] - 2022-01-31

### Changed in 1.0.1

- Moved from `data/1.0.0` to `data/2.0.0`.

## [1.0.0] - 2020-06-17

### Added to 1.0.0

- Initial features
