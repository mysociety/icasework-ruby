# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Resource::Payload do
  describe '.process' do
    subject(:payload) { described_class.process(data) }

    let(:data) do
      {
        customer: { email: 'alice@localhost', name: 'Alice' },
        type: 'Information Request'
      }
    end

    let(:converted) do
      {
        'Customer.Email' => 'alice@localhost',
        'Customer.Name' => 'Alice',
        'Type' => 'Information Request'
      }
    end

    it { is_expected.to eq(converted) }

    context 'with valid keys' do
      let(:data) do
        {
          db: 'test',
          fromseq: 0,
          toseq: 10,
          grant_type: 'bearer',
          assertion: 'jwt',
          access_token: 'token'
        }
      end

      it 'does not convert case of the keys' do
        expect(payload).to eq(
          'db' => 'test', 'fromseq' => 0, 'toseq' => 10,
          'grant_type' => 'bearer', 'assertion' => 'jwt',
          'access_token' => 'token'
        )
      end
    end
  end
end
