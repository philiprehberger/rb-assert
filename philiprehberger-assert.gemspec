# frozen_string_literal: true

require_relative 'lib/philiprehberger/assert/version'

Gem::Specification.new do |spec|
  spec.name          = 'philiprehberger-assert'
  spec.version       = Philiprehberger::Assert::VERSION
  spec.authors       = ['Philip Rehberger']
  spec.email         = ['me@philiprehberger.com']

  spec.summary       = 'Standalone runtime assertion library with chainable matchers'
  spec.description   = 'A lightweight runtime assertion library for Ruby with chainable ' \
                       'matchers, soft assertions, and Design by Contract preconditions.'
  spec.homepage      = 'https://philiprehberger.com/open-source-packages/ruby/philiprehberger-assert'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri']       = 'https://github.com/philiprehberger/rb-assert'
  spec.metadata['changelog_uri']         = 'https://github.com/philiprehberger/rb-assert/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/philiprehberger/rb-assert/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
