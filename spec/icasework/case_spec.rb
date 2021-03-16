# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Case do
  describe '.where' do
    subject(:cases) { described_class.where(payload) }

    let(:uri) { 'https://uatportal.icasework.com/getcases' }
    let(:payload) { { 'Type' => 'InformationRequest' } }
    let(:token) do
      Icasework::Token::Bearer.new(
        { 'access_token' => 'mock_token', 'token_type' => 'bearer',
          'expires_in' => 3600 }
      )
    end

    before do
      allow(Icasework::Token::Bearer).to receive(:generate).and_return(token)
      stub_request(:get, /#{uri}.*/).to_return(
        File.new('spec/fixtures/getcases_success.txt')
      )
    end

    it 'calls the GET getcases endpoint with payload' do
      cases
      expect(WebMock).to have_requested(:get, "#{uri}?db=test").with(
        query: { 'Format' => 'xml', 'Type' => 'InformationRequest' }
      ).once
    end

    context 'when successful' do
      it { is_expected.to be_an Array }
      it { is_expected.to all(be_an(described_class)) }
      it { expect(cases.count).to eq 2 }
    end
  end

  describe '.create' do
    subject(:create_case) { described_class.create(payload) }

    let(:uri) { 'https://uat.icasework.com/createcase' }
    let(:payload) { { 'Type' => 'InformationRequest' } }
    let(:token) do
      Icasework::Token::Bearer.new(
        { 'access_token' => 'mock_token', 'token_type' => 'bearer',
          'expires_in' => 3600 }
      )
    end

    before do
      allow(Icasework::Token::Bearer).to receive(:generate).and_return(token)
      stub_request(:post, /#{uri}.*/).to_return(
        File.new('spec/fixtures/createcase_success.txt')
      )
    end

    it 'calls the POST createcase endpoint with payload' do
      create_case
      expect(WebMock).to have_requested(:post, "#{uri}?db=test").with(
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
        body: { 'Format' => 'xml', 'Type' => 'InformationRequest' }
      ).once
    end

    context 'when successful' do
      it { is_expected.to be_an described_class }
    end
  end

  describe '#case_id' do
    subject { instance.case_id }

    let(:instance) { described_class.new('CaseDetails.CaseId' => 123) }

    it { is_expected.to eq 123 }
  end
end
