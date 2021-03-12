# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Resource do
  describe '.token' do
    subject(:resource) { described_class.token }

    it 'returns POST method' do
      expect(resource.method).to eq :post
    end

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

    it 'returns GET method' do
      expect(resource.method).to eq :get
    end

    it 'returns getcases endpoint' do
      expect(resource.url).to eq 'https://uatportal.icasework.com/getcases?db=test'
    end
  end

  describe '.get_case_attribute' do
    subject(:resource) { described_class.get_case_attribute }

    include_examples 'authorise resource'

    it 'returns GET method' do
      expect(resource.method).to eq :get
    end

    it 'returns getcaseattribute endpoint' do
      expect(resource.url).to eq 'https://uat.icasework.com/getcaseattribute?db=test'
    end
  end

  describe '.get_case_details' do
    subject(:resource) { described_class.get_case_details }

    include_examples 'authorise resource'

    it 'returns GET method' do
      expect(resource.method).to eq :get
    end

    it 'returns getcasedetails endpoint' do
      expect(resource.url).to eq 'https://uat.icasework.com/getcasedetails?db=test'
    end
  end

  describe '.get_case_documents' do
    subject(:resource) { described_class.get_case_documents }

    include_examples 'authorise resource'

    it 'returns GET method' do
      expect(resource.method).to eq :get
    end

    it 'returns getcasedocuments endpoint' do
      expect(resource.url).to eq 'https://uat.icasework.com/getcasedocuments?db=test'
    end
  end

  describe '.create_case' do
    subject(:resource) { described_class.create_case }

    include_examples 'authorise resource'

    it 'returns POST method' do
      expect(resource.method).to eq :post
    end

    it 'returns createcase endpoint' do
      expect(resource.url).to eq 'https://uat.icasework.com/createcase?db=test'
    end
  end

  describe '#GET requests' do
    let(:uri) { 'http://example.com' }
    let(:options) { { include_format: false } }
    let(:payload) { {} }

    before do
      stub_request(:get, %r{http://example\.com/.*}).and_return(body: '{}')
      described_class.new(uri: uri, options: options).get(payload.dup).data
    end

    context 'with include format equals false option' do
      it 'does not add JSON format param' do
        expect(WebMock).to have_requested(:get, uri).with(
          query: {}
        ).once
      end
    end

    context 'without include format option' do
      let(:options) { {} }

      it 'add JSON format param' do
        expect(WebMock).to have_requested(:get, uri).with(
          query: { Format: 'json' }
        ).once
      end
    end

    context 'with include format option' do
      let(:options) { { include_format: true } }

      it 'add JSON format param' do
        expect(WebMock).to have_requested(:get, uri).with(
          query: { 'Format' => 'json' }
        ).once
      end
    end

    context 'with payload' do
      let(:payload) { { 'Foo' => 'bar' } }

      it 'submits payload keys' do
        expect(WebMock).to have_requested(:get, uri).with(
          query: { 'Foo' => 'bar' }
        ).once
      end
    end
  end

  describe '#POST requests' do
    let(:uri) { 'http://example.com' }
    let(:options) { { include_format: false } }
    let(:payload) { {} }

    before do
      stub_request(:post, %r{http://example\.com/.*}).and_return(body: '{}')
      described_class.new(uri: uri, options: options).post(payload.dup).data
    end

    context 'with include format equals false option' do
      it 'does not add JSON format param' do
        expect(WebMock).to have_requested(:post, uri).with(
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
          body: {}
        ).once
      end
    end

    context 'without include format option' do
      let(:options) { {} }

      it 'add JSON format param' do
        expect(WebMock).to have_requested(:post, uri).with(
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
          body: { 'Format' => 'json' }
        ).once
      end
    end

    context 'with include format option' do
      let(:options) { { include_format: true } }

      it 'add JSON format param' do
        expect(WebMock).to have_requested(:post, uri).with(
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
          body: { 'Format' => 'json' }
        ).once
      end
    end

    context 'with payload' do
      let(:payload) { { 'Foo' => 'bar' } }

      it 'submits payload keys' do
        expect(WebMock).to have_requested(:post, uri).with(
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
          body: { 'Foo' => 'bar' }
        ).once
      end
    end
  end
end
