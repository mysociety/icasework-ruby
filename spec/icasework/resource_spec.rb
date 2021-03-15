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

  describe '#url' do
    subject { instance.url }

    let(:path) { 'path' }
    let(:options) { {} }
    let(:instance) { described_class.new(:foo, path, {}, **options) }

    context 'with subdomain option' do
      let(:options) { { subdomain: 'custom' } }

      it { is_expected.to eq 'https://custom.icasework.com/path?db=test' }
    end

    context 'without subdomain option' do
      it { is_expected.to eq 'https://uat.icasework.com/path?db=test' }
    end

    context 'when production ENV, with subdomain option' do
      before do
        allow(Icasework).to receive(:production?).and_return(true)
      end

      let(:options) { { subdomain: 'custom' } }

      it { is_expected.to eq 'https://test.icasework.com/path' }
    end
  end

  describe '#headers' do
    subject { instance.headers }

    let(:options) { {} }
    let(:instance) { described_class.new(:foo, '', {}, **options) }

    context 'when request should be authorised' do
      before do
        allow(Icasework::Token::Bearer).to receive(:generate).and_return('ABC')
      end

      it { is_expected.to eq(authorization: 'Bearer ABC') }
    end

    context 'when request should not be authorised' do
      let(:options) { { authorised: false } }

      it { is_expected.to eq({}) }
    end
  end

  describe '#payload' do
    subject { instance.payload }

    let(:method) { nil }
    let(:options) { {} }
    let(:instance) do
      described_class.new(method, '', { Foo: 'bar' }, **options)
    end

    context 'when POST request, with format option' do
      let(:method) { :post }

      it { is_expected.to eq(Format: 'json', Foo: 'bar') }
    end

    context 'when POST request, without format option' do
      let(:method) { :post }
      let(:options) { { format: nil } }

      it { is_expected.to eq(Foo: 'bar') }
    end

    context 'when GET request, with format option' do
      let(:method) { :get }

      it { is_expected.to eq(params: { Format: 'json', Foo: 'bar' }) }
    end

    context 'when GET request, without format option' do
      let(:method) { :get }
      let(:options) { { format: nil } }

      it { is_expected.to eq(params: { Foo: 'bar' }) }
    end
  end

  describe '#data' do
    let(:method) { nil }
    let(:instance) do
      described_class.new(method, '', { Foo: 'bar' })
    end

    before do
      allow(instance).to receive(:url).and_return('http://example.com')
      allow(instance).to receive(:headers).and_return({})
      allow(instance).to receive(:format).and_return(nil)

      stub_request(method, %r{http://example\.com/.*}).and_return(body: '{}')

      instance.data
    end

    context 'when GET request' do
      let(:method) { :get }

      it 'performs remote request with URL query params' do
        expect(WebMock).to have_requested(:get, 'http://example.com').with(
          query: { 'Foo' => 'bar' }
        ).once
      end
    end

    context 'when POST request' do
      let(:method) { :post }

      it 'performs remote request with form data' do
        expect(WebMock).to have_requested(:post, 'http://example.com').with(
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
          body: { 'Foo' => 'bar' }
        ).once
      end
    end
  end
end
