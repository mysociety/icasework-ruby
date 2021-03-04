# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Resource do
  describe '.token' do
    subject(:resource) { described_class.token }

    it 'returns token endpoint' do
      expect(resource.url).to eq 'https://uat.icasework.com/token?db=test'
    end
  end

  shared_examples 'authorise resource' do
    before do
      allow(Icasework::Token::Bearer).to receive(:generate).and_return(
        '<token>'
      )
    end

    it 'authorisation header' do
      expect(resource.headers).to include(authorization: 'Bearer <token>')
    end
  end

  describe '.get_cases' do
    subject(:resource) { described_class.get_cases }
    include_examples 'authorise resource'

    it 'returns getcases endpoint' do
      expect(resource.url).to eq 'https://uatportal.icasework.com/getcases?db=test'
    end
  end
end
