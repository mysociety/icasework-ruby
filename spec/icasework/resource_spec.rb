# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Resource do
  describe '.token' do
    subject(:resource) { described_class.token }

    it 'returns POST token endpoint' do
      expect(resource.method).to eq :post
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

    it 'returns GET getcases endpoint' do
      expect(resource.method).to eq :get
      expect(resource.url).to eq 'https://uatportal.icasework.com/getcases?db=test'
    end
  end

  describe '#GET requests' do
    let(:uri) { 'http://example.com' }
    let(:options) { { include_format: false } }
    let(:payload) { {} }

    before do
      stub_request(:get, %r{http://example\.com/.*}).and_return(body: '{}')
      described_class.new(uri: uri, options: options).get(payload).data
    end

    context 'with payload' do
      let(:payload) { { foo: 'bar' } }

      it 'passes payload to endpoint as query params' do
        expect(WebMock).to have_requested(:get, uri).with(
          query: { foo: 'bar' }
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
      described_class.new(uri: uri, options: options).post(payload).data
    end

    context 'with payload' do
      let(:payload) { { foo: 'bar' } }

      it 'passes payload to endpoint as form URL encoded body' do
        expect(WebMock).to have_requested(:post, uri).with(
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
          body: { foo: 'bar' }
        ).once
      end
    end
  end
end
