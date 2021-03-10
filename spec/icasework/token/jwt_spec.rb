# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Token::JWT do
  describe '.generate' do
    subject(:jwt) { described_class.generate }

    before { Timecop.freeze(Time.parse('2021-03-03 09:40:00 +0000')) }

    let(:expected_token) do
      <<~JWT.delete("\n")
        eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJmb28iLCJhdWQiOiJodHRwczovL3VhdC5pY2FzZXd
        vcmsuY29tL3Rva2VuP2RiPXRlc3QiLCJpYXQiOjE2MTQ3NjQ0MDB9.CyKQfSfX44ZM9zC6kd
        PuGfHacO50XSOvUbbWc8xt-7U
      JWT
    end

    it { is_expected.to be_a described_class }

    it 'generates expected token' do
      expect(jwt).to eq expected_token
    end
  end

  shared_context 'with instance' do
    let(:instance) { described_class.new('jwt') }
  end

  describe '#to_s' do
    include_context 'with instance'

    it 'returns token' do
      expect(instance.to_s).to eq 'jwt'
    end
  end

  describe '#==' do
    subject { instance == other_token }

    include_context 'with instance'

    context 'when comparing a matching token' do
      let(:other_token) { 'jwt' }

      it { is_expected.to eq true }
    end

    context 'when comparing a not matching token' do
      let(:other_token) { 'other' }

      it { is_expected.to eq false }
    end
  end
end
