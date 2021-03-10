# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework do
  it 'has a version number' do
    expect(Icasework::VERSION).not_to be nil
  end

  describe 'account' do
    it 'must be assignable' do
      described_class.account = 'account'
      expect(described_class.account).to eq 'account'
    end

    it 'must raise an exception when not set' do
      if described_class.instance_variable_defined?(:@account)
        described_class.send(:remove_instance_variable, :@account)
      end
      expect { described_class.account }.to raise_error(ConfigurationError)
    end

    it 'must raise an exception when set to nil' do
      described_class.account = nil
      expect { described_class.account }.to raise_error(ConfigurationError)
    end
  end

  describe 'api key' do
    it 'must be assignable' do
      described_class.api_key = 'new_key'
      expect(described_class.api_key).to eq 'new_key'
    end

    it 'must raise an exception when not set' do
      if described_class.instance_variable_defined?(:@api_key)
        described_class.send(:remove_instance_variable, :@api_key)
      end
      expect { described_class.api_key }.to raise_error(ConfigurationError)
    end

    it 'must raise an exception when set to nil' do
      described_class.api_key = nil
      expect { described_class.api_key }.to raise_error(ConfigurationError)
    end
  end

  describe 'secret_key' do
    it 'must be assignable' do
      described_class.secret_key = 'secret_key'
      expect(described_class.secret_key).to eq 'secret_key'
    end

    it 'must raise an exception when not set' do
      if described_class.instance_variable_defined?(:@secret_key)
        described_class.send(:remove_instance_variable, :@secret_key)
      end
      expect { described_class.secret_key }.to raise_error(ConfigurationError)
    end

    it 'must raise an exception when set to nil' do
      described_class.secret_key = nil
      expect { described_class.secret_key }.to raise_error(ConfigurationError)
    end
  end

  describe 'production?' do
    it 'must be assignable via .env=' do
      described_class.env = 'production'
      expect(described_class.production?).to be true
    end

    it 'return true when not set' do
      if described_class.instance_variable_defined?(:@production)
        described_class.send(:remove_instance_variable, :@production)
      end
      expect(described_class.production?).to be false
    end

    it 'returns true when set to nil' do
      described_class.env = nil
      expect(described_class.production?).to be false
    end
  end
end
