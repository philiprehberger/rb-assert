# philiprehberger-assert

[![Tests](https://github.com/philiprehberger/rb-assert/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-assert/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-assert.svg)](https://rubygems.org/gems/philiprehberger-assert)
[![License](https://img.shields.io/github/license/philiprehberger/rb-assert)](LICENSE)

Standalone runtime assertion library with chainable matchers for Ruby.

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-assert"
```

Or install directly:

```bash
gem install philiprehberger-assert
```

## Usage

```ruby
require "philiprehberger/assert"
```

### Basic Assertions

```ruby
Philiprehberger::Assert.that(42).is_a(Integer)
Philiprehberger::Assert.that('hello').not_blank.matches(/^hel/)
```

### Chainable Matchers

```ruby
Philiprehberger::Assert.that(age).is_a(Integer).gte(0).lte(150)
Philiprehberger::Assert.that(config).includes_key(:host)
Philiprehberger::Assert.that(items).not_empty
```

### Custom Messages

```ruby
Philiprehberger::Assert.that(value, 'value must be a positive number').is_a(Integer).gt(0)
```

### Soft Assertions

Collect all failures instead of stopping at the first one:

```ruby
Philiprehberger::Assert.soft do |a|
  a.call(name).not_blank
  a.call(age).is_a(Integer).gte(0)
  a.call(email).matches(/@/)
end
# raises MultipleFailures with all failed assertions
```

### Preconditions (Design by Contract)

```ruby
Philiprehberger::Assert.precondition(user.active?, 'user must be active')
```

## API

| Method | Description |
|--------|-------------|
| `Assert.that(value, message = nil)` | Start a chainable assertion |
| `Assert.soft { \|a\| ... }` | Collect failures, raise at end |
| `Assert.precondition(condition, message)` | Design by Contract check |
| `Assertion#is_a(type)` | Assert value is an instance of type |
| `Assertion#gte(num)` | Assert value >= num |
| `Assertion#lte(num)` | Assert value <= num |
| `Assertion#gt(num)` | Assert value > num |
| `Assertion#lt(num)` | Assert value < num |
| `Assertion#matches(pattern)` | Assert value matches regex pattern |
| `Assertion#not_blank` | Assert value is not nil or blank |
| `Assertion#not_empty` | Assert value is not empty |
| `Assertion#includes_key(key)` | Assert hash includes key |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
