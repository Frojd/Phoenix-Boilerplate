# Changelog

# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
### Changed
- Rename .tool-versions to local.tool-versions to indicate it is only used locally
- Replace distillery with mix release

### Fixed
- Upgrade Elixir to 1.16
- Upgrade Ubuntu to 22.04
- Add Circle CI executors
- Bump actions/checkout to v4
- Upgrade Phoenix to 1.7

### Removed

## [2.1.0] - 2022-01-06

### Fixed
- Upgrade Phoenix to 1.6.6
- Upgrade Elixir to 1.13
- Use official elixir docker image for development
- Use IP 0.0.0.0 for local phoenix server


## [2.0.1] - 2021-05-26

### Added
- Add CI for testing boilerplate (Martin Sandström)

### Fixed
- Move SSL handling to Nginx (Martin Sandström)


## [2.0.0] - 2021-05-11

### Added
- Use Nginx as a server proxy (Martin Sandström)
- Add way of runnign dock containeraized and local version of Elixir (Martin Sandström)
- Add command for cleaning up scaffolded files (Martin Sandström)
- Add MIT license

### Fixxed
- Add security
- Upgrade Elixir to 1.11 (Martin Sandström)
- Upgrade Phoenix to 1.5 (Martin Sandström)
- Use PostgreSQL 12 (Martin Sandström)
