# frozen_string_literal: true

module Philiprehberger
  module Assert
    # Chainable assertion object returned by Assert.that.
    class Assertion
      def initialize(value, message: nil, failures: nil)
        @value = value
        @message = message
        @failures = failures
      end

      def is_a(type) # rubocop:disable Naming/PredicatePrefix
        check(@value.is_a?(type), "Expected #{@value.inspect} to be a #{type}")
      end

      def gte(num)
        check(@value >= num, "Expected #{@value.inspect} to be >= #{num}")
      end

      def lte(num)
        check(@value <= num, "Expected #{@value.inspect} to be <= #{num}")
      end

      def gt(num)
        check(@value > num, "Expected #{@value.inspect} to be > #{num}")
      end

      def lt(num)
        check(@value < num, "Expected #{@value.inspect} to be < #{num}")
      end

      def matches(pattern)
        check(pattern.match?(@value.to_s), "Expected #{@value.inspect} to match #{pattern.inspect}")
      end

      def not_blank
        check(!@value.nil? && !@value.to_s.strip.empty?, 'Expected value to not be blank')
      end

      def not_empty
        check(@value.respond_to?(:empty?) && !@value.empty?, 'Expected value to not be empty')
      end

      def includes_key(key)
        check(@value.respond_to?(:key?) && @value.key?(key), "Expected #{@value.inspect} to include key #{key.inspect}")
      end

      private

      def check(condition, default_message)
        msg = @message || default_message
        if condition
          self
        elsif @failures
          @failures << msg
          self
        else
          raise AssertionError, msg
        end
      end
    end
  end
end
