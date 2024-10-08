# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Assert do
  describe 'VERSION' do
    it 'has a version number' do
      expect(Philiprehberger::Assert::VERSION).not_to be_nil
    end
  end

  describe '.that' do
    it 'returns an Assertion' do
      expect(described_class.that(42)).to be_a(Philiprehberger::Assert::Assertion)
    end

    it 'passes is_a check for correct type' do
      expect { described_class.that(42).is_a(Integer) }.not_to raise_error
    end

    it 'fails is_a check for wrong type' do
      expect { described_class.that(42).is_a(String) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'chains gte and lte' do
      expect { described_class.that(5).gte(1).lte(10) }.not_to raise_error
    end

    it 'fails gte when value is too small' do
      expect { described_class.that(0).gte(1) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'fails lte when value is too large' do
      expect { described_class.that(11).lte(10) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'passes gt and lt' do
      expect { described_class.that(5).gt(4).lt(6) }.not_to raise_error
    end

    it 'passes matches with a matching pattern' do
      expect { described_class.that('hello').matches(/^hel/) }.not_to raise_error
    end

    it 'fails matches with a non-matching pattern' do
      expect { described_class.that('hello').matches(/^xyz/) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'passes not_blank for non-blank string' do
      expect { described_class.that('hello').not_blank }.not_to raise_error
    end

    it 'fails not_blank for blank string' do
      expect { described_class.that('  ').not_blank }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'passes not_empty for non-empty array' do
      expect { described_class.that([1]).not_empty }.not_to raise_error
    end

    it 'fails not_empty for empty array' do
      expect { described_class.that([]).not_empty }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'passes includes_key for present key' do
      expect { described_class.that({ a: 1 }).includes_key(:a) }.not_to raise_error
    end

    it 'fails includes_key for missing key' do
      expect { described_class.that({ a: 1 }).includes_key(:b) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end
  end

  describe '.soft' do
    it 'collects multiple failures' do
      expect do
        described_class.soft do |a|
          a.call(42).is_a(String)
          a.call('').not_blank
        end
      end.to raise_error(Philiprehberger::Assert::MultipleFailures) { |e|
        expect(e.messages.length).to eq(2)
      }
    end

    it 'does not raise when all assertions pass' do
      expect do
        described_class.soft do |a|
          a.call(42).is_a(Integer)
          a.call('hello').not_blank
        end
      end.not_to raise_error
    end
  end

  describe '.precondition' do
    it 'passes for a truthy condition' do
      expect { described_class.precondition(true, 'must be true') }.not_to raise_error
    end

    it 'fails for a falsey condition' do
      expect { described_class.precondition(false, 'must be true') }.to raise_error(
        Philiprehberger::Assert::AssertionError, 'must be true'
      )
    end

    it 'passes for a truthy non-boolean value' do
      expect { described_class.precondition(1, 'must be truthy') }.not_to raise_error
    end

    it 'fails for nil condition' do
      expect { described_class.precondition(nil, 'must not be nil') }.to raise_error(
        Philiprehberger::Assert::AssertionError, 'must not be nil'
      )
    end
  end

  describe '.that with not_blank' do
    it 'fails for nil' do
      expect { described_class.that(nil).not_blank }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'fails for empty string' do
      expect { described_class.that('').not_blank }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'passes for a string with content' do
      expect { described_class.that('x').not_blank }.not_to raise_error
    end
  end

  describe '.that with not_empty' do
    it 'fails for empty hash' do
      expect { described_class.that({}).not_empty }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'passes for non-empty hash' do
      expect { described_class.that({ a: 1 }).not_empty }.not_to raise_error
    end

    it 'fails for empty string' do
      expect { described_class.that('').not_empty }.to raise_error(Philiprehberger::Assert::AssertionError)
    end
  end

  describe '.that with matches' do
    it 'matches a numeric pattern' do
      expect { described_class.that('abc123').matches(/\d+/) }.not_to raise_error
    end

    it 'fails when pattern does not match' do
      expect { described_class.that('abc').matches(/\d+/) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'converts non-string values via to_s' do
      expect { described_class.that(42).matches(/^\d+$/) }.not_to raise_error
    end
  end

  describe '.that with gte and lte boundary' do
    it 'passes gte at exact boundary' do
      expect { described_class.that(5).gte(5) }.not_to raise_error
    end

    it 'passes lte at exact boundary' do
      expect { described_class.that(5).lte(5) }.not_to raise_error
    end
  end

  describe '.that with gt and lt boundary' do
    it 'fails gt at exact boundary' do
      expect { described_class.that(5).gt(5) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'fails lt at exact boundary' do
      expect { described_class.that(5).lt(5) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end
  end

  describe 'chaining multiple assertions' do
    it 'chains three assertions successfully' do
      expect { described_class.that(5).gte(1).lte(10).is_a(Integer) }.not_to raise_error
    end

    it 'fails on the second assertion in a chain' do
      expect { described_class.that(5).gte(1).lte(3) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end
  end

  describe '.soft collecting multiple failures' do
    it 'reports correct number of failures' do
      expect do
        described_class.soft do |a|
          a.call(42).is_a(String)
          a.call(42).is_a(Integer)
          a.call('').not_blank
          a.call([]).not_empty
        end
      end.to raise_error(Philiprehberger::Assert::MultipleFailures) { |e|
        expect(e.messages.length).to eq(3)
      }
    end

    it 'includes descriptive messages' do
      expect do
        described_class.soft do |a|
          a.call(42).is_a(String)
        end
      end.to raise_error(Philiprehberger::Assert::MultipleFailures) { |e|
        expect(e.message).to include('Expected 42 to be a String')
      }
    end
  end

  describe '.that with custom message' do
    it 'uses custom message on failure' do
      expect { described_class.that(42, 'must be string').is_a(String) }.to raise_error(
        Philiprehberger::Assert::AssertionError, 'must be string'
      )
    end

    it 'does not affect passing assertions' do
      expect { described_class.that(42, 'custom').is_a(Integer) }.not_to raise_error
    end
  end

  describe '.that with between' do
    it 'passes when value is within range' do
      expect { described_class.that(5).between(1, 10) }.not_to raise_error
    end

    it 'passes at lower boundary' do
      expect { described_class.that(1).between(1, 10) }.not_to raise_error
    end

    it 'passes at upper boundary' do
      expect { described_class.that(10).between(1, 10) }.not_to raise_error
    end

    it 'raises when below range' do
      expect { described_class.that(0).between(1, 10) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'raises when above range' do
      expect { described_class.that(11).between(1, 10) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'supports custom message' do
      expect { described_class.that(0, 'bad value').between(1, 10) }.to raise_error(Philiprehberger::Assert::AssertionError, 'bad value')
    end
  end

  describe '.that with one_of' do
    it 'passes when value is in the list' do
      expect { described_class.that(:red).one_of(:red, :green, :blue) }.not_to raise_error
    end

    it 'raises when value is not in the list' do
      expect { described_class.that(:yellow).one_of(:red, :green, :blue) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'works with strings' do
      expect { described_class.that('a').one_of('a', 'b', 'c') }.not_to raise_error
    end

    it 'supports custom message' do
      expect do
  described_class.that(:yellow, 'invalid color').one_of(:red,
                                                        :green)
end.to raise_error(Philiprehberger::Assert::AssertionError, 'invalid color')
    end
  end

  describe '.that with responds_to' do
    it 'passes when value responds to method' do
      expect { described_class.that('hello').responds_to(:upcase) }.not_to raise_error
    end

    it 'passes for multiple methods' do
      expect { described_class.that('hello').responds_to(:upcase, :downcase, :length) }.not_to raise_error
    end

    it 'raises when value does not respond to method' do
      expect { described_class.that(42).responds_to(:upcase) }.to raise_error(Philiprehberger::Assert::AssertionError)
    end

    it 'lists all missing methods in error' do
      expect do
  described_class.that(42).responds_to(:upcase, :downcase)
end.to raise_error(Philiprehberger::Assert::AssertionError, /upcase, downcase/)
    end
  end

  describe 'new matchers are chainable' do
    it 'chains between with other matchers' do
      expect { described_class.that(5).is_a(Integer).between(1, 10) }.not_to raise_error
    end

    it 'chains one_of with other matchers' do
      expect { described_class.that(:red).is_a(Symbol).one_of(:red, :green) }.not_to raise_error
    end

    it 'chains responds_to with other matchers' do
      expect { described_class.that('hi').is_a(String).responds_to(:length).not_blank }.not_to raise_error
    end
  end

  describe 'new matchers in soft mode' do
    it 'collects failures from new matchers' do
      expect do
        described_class.soft do |a|
          a.call(0).between(1, 10)
          a.call(:yellow).one_of(:red, :green)
          a.call(42).responds_to(:upcase)
        end
      end.to raise_error(Philiprehberger::Assert::MultipleFailures) { |e| expect(e.messages.size).to eq(3) }
    end
  end

  describe 'error classes' do
    it 'AssertionError is a subclass of StandardError' do
      expect(Philiprehberger::Assert::AssertionError).to be < StandardError
    end

    it 'MultipleFailures is a subclass of StandardError' do
      expect(Philiprehberger::Assert::MultipleFailures).to be < StandardError
    end

    it 'MultipleFailures exposes messages array' do
      described_class.soft do |a|
        a.call(nil).not_blank
      end
    rescue Philiprehberger::Assert::MultipleFailures => e
      expect(e.messages).to be_an(Array)
      expect(e.messages.length).to eq(1)
    end
  end
end
