# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Token::Bearer do
  describe '.generate' do
    subject(:bearer) { described_class.generate }

    let(:uri) { 'https://uat.icasework.com/token?db=test' }
    let(:jwt) { Icasework::Token::JWT.new('mock_jwt') }

    before do
      allow(Icasework::Token::JWT).to receive(:generate).and_return(jwt)
      stub_request(:post, uri).to_return(response)
    end

    let(:response) do
      {
        status: 200,
        body: { access_token: nil, token_type: nil, expires_in: nil }.to_json
      }
    end

    let(:payload) do
      URI.encode_www_form(
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion: jwt
      )
    end

    it 'calls the token endpoint with payload' do
      bearer
      expect(WebMock).to have_requested(:post, uri).with(
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
        body: payload
      ).once
    end

    context 'when successful' do
      let(:response) do
        File.new('spec/fixtures/token_success.txt')
      end

      it { is_expected.to be_a Icasework::Token::Bearer }
    end

    context 'when incorrect credentials' do
      let(:response) do
        File.new('spec/fixtures/token_incorrect_credentials.txt')
      end

      it 'raises authentication error' do
        expect { bearer }.to raise_error(AuthenticationError)
      end
    end

    context 'when wrong database' do
      let(:response) do
        File.new('spec/fixtures/token_wrong_database.txt')
      end

      it 'raises authentication error' do
        expect { bearer }.to raise_error(AuthenticationError)
      end
    end
  end

  shared_context 'with instance' do
    let(:mock_data) do
      {
        'access_token' => 'token',
        'token_type' => 'bearer',
        'expires_in' => 3600
      }
    end

    let(:instance) { Icasework::Token::Bearer.new(mock_data) }
  end

  describe '#to_s' do
    include_context 'with instance'

    it 'returns access token' do
      expect(instance.to_s).to eq 'token'
    end
  end
end
