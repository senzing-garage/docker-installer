# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2025-09-02

### Changed in 2.0.1

- Update for Senzing V4

## [2.0.0] - 2026-08-19

### Changed in 2.0.0

- Modify for forthcoming Senzing V4

## [1.3.7] - 2024-06-25

### Changed in 1.3.7

- Add debugging information and improve instructions

## [1.3.6] - 2024-06-24

### Changed in 1.3.6

- In `Dockerfile`, updated FROM instruction to `debian:11.9-slim@sha256:acc5810124f0929ab44fc7913c0ad936b074cbd3eadf094ac120190862ba36c4`

## [1.3.5] - 2024-05-22

### Changed in 1.3.5

- In `Dockerfile`, updated
  - FROM instruction to `debian:11.9-slim@sha256:0e75382930ceb533e2f438071307708e79dc86d9b8e433cc6dd1a96872f2651d`
  - `senzingrepo_2.0.0-1_all.deb`

## [1.3.4] - 2024-03-18

### Changed in 1.3.4

- In `Dockerfile`, updated FROM instruction to `debian:11.9-slim@sha256:a165446a88794db4fec31e35e9441433f9552ae048fb1ed26df352d2b537cb96`

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
