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
  end
end
