# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Case do
  let(:token) do
    Icasework::Token::Bearer.new(
      { access_token: 'mock_token', token_type: 'bearer', expires_in: 3600 }
    )
  end

  before do
    allow(Icasework::Token::Bearer).to receive(:generate).and_return(token)
  end

  describe '.where' do
    subject(:cases) { described_class.where(payload) }

    let(:uri) { 'https://uatportal.icasework.com/getcases' }
    let(:payload) { { type: 'InformationRequest' } }

    before do
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
    let(:payload) { { type: 'InformationRequest' } }

    before do
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

    let(:instance) { described_class.new(case_details: { case_id: 123 }) }

    it { is_expected.to eq 123 }
  end

  describe '#[]' do
    subject(:case_details) { instance[:case_details] }

    let(:instance) { described_class.new(case_details: { case_id: 123 }) }

    it { is_expected.to be_a(LazyHash) }

    context 'when requesting loaded key' do
      subject(:case_id) { case_details[:case_id] }

      it { is_expected.to eq 123 }

      it 'does not make an additional remote request' do
        case_id
        expect(WebMock).not_to have_requested(
          :get, 'https://uat.icasework.com/getcasedetails'
        )
      end
    end

    context 'when requesting unloaded key' do
      subject(:case_label) { case_details[:case_label] }

      before do
        stub_request(:get, %r{https://uat\.icasework\.com/getcasedetails.*}).
          to_return(File.new('spec/fixtures/getcasedetails_success.txt'))
      end

      it { is_expected.to eq 'IR - y' }

      it 'makes an additional remote request' do
        case_label
        expect(WebMock).to have_requested(
          :get, 'https://uat.icasework.com/getcasedetails'
        ).with(query: { Format: 'xml', CaseId: 123, db: 'test' }).once
      end
    end
  end

  describe '#classifications' do
    subject(:classifications) { instance.classifications }

    let(:instance) do
      described_class.new(
        classifications: [
          { group: 'About the council', __content__: 'Budgets spending' }
        ]
      )
    end

    it { is_expected.to all(be_a Classification) }

    it 'calls Classification initialiser with required attributes' do
      allow(Classification).to receive(:new).and_call_original
      instance.classifications
      expect(Classification).to have_received(:new).with(
        group: 'About the council', __content__: 'Budgets spending'
      )
    end
  end

  describe '#documents' do
    subject(:classifications) { instance.documents }

    let(:instance) do
      described_class.new(
        documents: [
          { id: 'D123', name: 'filename', __content__: 'Hello world' }
        ]
      )
    end

    it { is_expected.to all(be_a Document) }

    it 'calls Document initialiser with required attributes' do
      allow(Document).to receive(:new).and_call_original
      instance.documents
      expect(Document).to have_received(:new).with(
        id: 'D123', name: 'filename', __content__: 'Hello world'
      )
    end
  end
end
