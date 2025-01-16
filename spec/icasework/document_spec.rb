# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Document do
  let(:token) do
    Icasework::Token::Bearer.new(
      { access_token: 'mock_token', token_type: 'bearer', expires_in: 3600 }
    )
  end

  before do
    allow(Icasework::Token::Bearer).to receive(:generate).and_return(token)
  end

  describe '.where' do
    subject(:documents) { described_class.where(payload) }

    let(:uri) { 'https://uat.icasework.com/getcasedocuments' }
    let(:payload) { { case_id: 487_347 } }

    let(:response) do
      File.new('spec/fixtures/getcasedocuments_unknown_case_id.txt')
    end

    before { stub_request(:get, /#{uri}.*/).to_return(response) }

    it 'calls the GET getcasedocuments endpoint with payload' do
      documents
      expect(WebMock).to have_requested(:get, "#{uri}?db=test").with(
        query: { 'Format' => 'xml', 'CaseId' => 487_347 }
      ).once
    end

    context 'when successful' do
      let(:response) { File.new('spec/fixtures/getcasedocuments_success.txt') }

      it { is_expected.to be_an Array }
      it { is_expected.to all(be_a(described_class)) }
      it { expect(documents.count).to eq 1 }
    end

    context 'when unsuccessful' do
      it { is_expected.to be_an Array }
      it { is_expected.to be_empty }
    end
  end

  describe '#find' do
    subject(:document) { described_class.find(**payload) }

    before do
      allow(described_class).to receive(:where).and_return(
        [
          described_class.new(id: 'D225851'),
          described_class.new(id: 'D123')
        ]
      )
    end

    context 'with document ID' do
      let(:payload) { { case_id: 487_347, document_id: 'D225851' } }

      it 'calls #where with case_id' do
        document
        expect(described_class).to have_received(:where).with(case_id: 487_347)
      end

      it { is_expected.to be_a(described_class) }
      it { expect(document.attributes[:id]).to eq 'D225851' }
    end
  end

  describe '#pdf?' do
    subject { instance.pdf? }

    let(:instance) { described_class.new(type: type) }

    context 'with PDF mimitype' do
      let(:type) { 'application/pdf' }

      it { is_expected.to eq true }
    end

    context 'with other mimitype' do
      let(:type) { 'plain/text' }

      it { is_expected.to eq false }
    end
  end

  describe '#pdf_contents' do
    subject { instance.pdf_contents }

    let(:instance) { described_class.new(type: type, __content__: url) }
    let(:url) { 'https://example.com/document.pdf' }

    before do
      stub_request(:get, url).to_return(
        status: 200, body: File.new('spec/fixtures/document.pdf')
      )
    end

    context 'with PDF mimitype' do
      let(:type) { 'application/pdf' }

      it { is_expected.to eq 'Hello World' }
    end

    context 'with othe mimitype' do
      let(:type) { 'plain/text' }

      it { is_expected.to eq nil }
    end
  end
end
