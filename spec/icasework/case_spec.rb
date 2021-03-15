# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Case do
  describe '.where' do
    subject(:cases) { described_class.where(payload) }

    let(:uri) { 'https://uatportal.icasework.com/getcases' }
    let(:response) { { status: 200, body: [].to_json } }
    let(:payload) { { 'Type' => 'InformationRequest' } }
    let(:token) do
      Icasework::Token::Bearer.new(
        { 'access_token' => 'mock_token', 'token_type' => 'bearer',
          'expires_in' => 3600 }
      )
    end

    before do
      allow(Icasework::Token::Bearer).to receive(:generate).and_return(token)
      stub_request(:get, /#{uri}.*/).to_return(response)
    end

    it 'calls the GET getcases endpoint with payload' do
      cases
      expect(WebMock).to have_requested(:get, "#{uri}?db=test").with(
        query: { 'Format' => 'json', 'Type' => 'InformationRequest' }
      ).once
    end

    context 'when successful' do
      let(:response) do
        File.new('spec/fixtures/getcases_success.txt')
      end

      it { is_expected.to be_an Array }
      it { is_expected.to all(be_an(described_class)) }
    end
  end

  describe '.create' do
    subject(:create_case) { described_class.create(payload) }

    let(:uri) { 'https://uat.icasework.com/createcase' }
    let(:response) do
      { status: 200, body: { createcaseresponse: { caseid: 123 } }.to_json }
    end
    let(:payload) do
      { 'Format' => 'json', 'Type' => 'InformationRequest' }
    end
    let(:token) do
      Icasework::Token::Bearer.new(
        { 'access_token' => 'mock_token', 'token_type' => 'bearer',
          'expires_in' => 3600 }
      )
    end

    before do
      allow(Icasework::Token::Bearer).to receive(:generate).and_return(token)
      stub_request(:post, /#{uri}.*/).to_return(response)
    end

    it 'calls the POST createcase endpoint with payload' do
      create_case
      expect(WebMock).to have_requested(:post, "#{uri}?db=test").with(
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
        body: URI.encode_www_form(payload)
      ).once
    end

    context 'when successful' do
      let(:response) do
        File.new('spec/fixtures/createcase_success.txt')
      end

      it { is_expected.to be_an described_class }
    end
  end
end
