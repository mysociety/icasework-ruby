# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework do
  it 'has a version number' do
    expect(Icasework::VERSION).not_to be nil
  end

  describe 'account' do
    it 'must be assignable' do
      Icasework.account = 'account'
      expect(Icasework.account).to eq 'account'
    end

    it 'must raise an exception when not set' do
      if Icasework.instance_variable_defined?(:@account)
        Icasework.send(:remove_instance_variable, :@account)
      end
      expect { Icasework.account }.to raise_error(ConfigurationError)
    end

    it 'must raise an exception when set to nil' do
      Icasework.account = nil
      expect { Icasework.account }.to raise_error(ConfigurationError)
    end
  end

  describe 'api key' do
    it 'must be assignable' do
      Icasework.api_key = 'new_key'
      expect(Icasework.api_key).to eq 'new_key'
    end

    it 'must raise an exception when not set' do
      if Icasework.instance_variable_defined?(:@api_key)
        Icasework.send(:remove_instance_variable, :@api_key)
      end
      expect { Icasework.api_key }.to raise_error(ConfigurationError)
    end

    it 'must raise an exception when set to nil' do
      Icasework.api_key = nil
      expect { Icasework.api_key }.to raise_error(ConfigurationError)
    end
  end

  describe 'secret_key' do
    it 'must be assignable' do
      Icasework.secret_key = 'secret_key'
      expect(Icasework.secret_key).to eq 'secret_key'
    end

    it 'must raise an exception when not set' do
      if Icasework.instance_variable_defined?(:@secret_key)
        Icasework.send(:remove_instance_variable, :@secret_key)
      end
      expect { Icasework.secret_key }.to raise_error(ConfigurationError)
    end

    it 'must raise an exception when set to nil' do
      Icasework.secret_key = nil
      expect { Icasework.secret_key }.to raise_error(ConfigurationError)
    end
  end

  describe 'production?' do
    it 'must be assignable via .mode=' do
      Icasework.mode = :production
      expect(Icasework.production?).to be true
    end

    it 'return true when not set' do
      if Icasework.instance_variable_defined?(:@production)
        Icasework.send(:remove_instance_variable, :@production)
      end
      expect(Icasework.production?).to be false
    end

    it 'returns true when set to nil' do
      Icasework.mode = nil
      expect(Icasework.production?).to be false
    end
  end
end
