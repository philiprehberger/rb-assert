# frozen_string_literal: true

require_relative 'assert/version'
require_relative 'assert/errors'
require_relative 'assert/assertion'

module Philiprehberger
  module Assert
    # Create a chainable assertion for the given value.
    #
    # @param value the value to assert against
    # @param message [String, nil] optional custom failure message
    # @return [Assertion]
    def self.that(value, message = nil)
      Assertion.new(value, message: message)
    end

    # Collect assertion failures instead of raising immediately.
    #
    # @yield [proc] a proc that creates soft assertions
    # @raise [MultipleFailures] if any assertions failed
    def self.soft
      failures = []
      yield ->(value, message = nil) { Assertion.new(value, message: message, failures: failures) }
      raise MultipleFailures, failures unless failures.empty?
    end

    # Design by Contract precondition check.
    #
    # @param condition [Boolean] the condition to verify
    # @param message [String] failure message
    # @raise [AssertionError] if condition is false
    def self.precondition(condition, message)
      raise AssertionError, message unless condition
    end
  end
end
