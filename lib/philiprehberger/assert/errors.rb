# frozen_string_literal: true

module Philiprehberger
  module Assert
    # Raised when a single assertion fails.
    class AssertionError < StandardError; end

    # Raised after a soft assertion block when one or more assertions failed.
    class MultipleFailures < StandardError
      attr_reader :messages

      def initialize(messages)
        @messages = messages
        super("Multiple assertion failures:\n#{messages.map { |m| "  - #{m}" }.join("\n")}")
      end
    end
  end
end
