# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Resource do
  describe '.token' do
    subject(:resource) { described_class.token }

    it 'returns token endpoint' do
      expect(resource.url).to eq 'https://uat.icasework.com/token?db=test'
    end
  end
end
