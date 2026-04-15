# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2026-04-15

### Added
- `starts_with(prefix)` matcher for string prefix assertions
- `ends_with(suffix)` matcher for string suffix assertions

## [0.3.0] - 2026-04-04

### Added
- `satisfies(description = nil, &block)` matcher for custom block-based assertions

## [0.2.0] - 2026-04-04

### Added
- `between(min, max)` matcher for range assertions
- `one_of(*values)` matcher for membership assertions
- `responds_to(*methods)` matcher for interface assertions
- GitHub issue template gem version field
- Feature request "Alternatives considered" field

## [0.1.11] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.1.10] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.1.9] - 2026-03-26

### Changed

- Add Sponsor badge and fix License link format in README

## [0.1.8] - 2026-03-24

### Fixed
- Fix README one-liner to remove trailing period and match gemspec summary

## [0.1.7] - 2026-03-24

### Fixed
- Standardize README code examples to use double-quote require statements
- Remove inline comments from Development section to match template

## [0.1.6] - 2026-03-22

### Added
- Expanded test suite from 20 to 30+ examples covering all matcher types, chainable assertions, soft mode, custom messages, error classes, and boundary conditions

## [0.1.5] - 2026-03-21

### Fixed
- Standardize Installation section in README

## [0.1.4] - 2026-03-18

### Changed
- Revert gemspec to single-quoted strings per RuboCop default configuration

## [0.1.3] - 2026-03-18

### Fixed
- Fix RuboCop Style/StringLiterals violations in gemspec

## [0.1.2] - 2026-03-16

### Changed
- Add License badge to README
- Add bug_tracker_uri to gemspec

## [0.1.1] - 2026-03-15

## [0.1.0] - 2026-03-15

### Added
- Initial release
- Chainable assertion matchers
- Soft assertions collecting all failures
- Precondition/postcondition helpers
- Type comparison and pattern checks
