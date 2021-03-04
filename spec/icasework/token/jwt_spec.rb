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

    it { is_expected.to be_a Icasework::Token::JWT }

    it 'generates expected token' do
      expect(jwt).to eq expected_token
    end
  end

  shared_context 'with instance' do
    let(:instance) { Icasework::Token::JWT.new('jwt') }
  end

  describe '#to_s' do
    include_context 'with instance'

    it 'returns token' do
      expect(instance.to_s).to eq 'jwt'
    end
  end

  describe '#==' do
    include_context 'with instance'

    it 'compares token' do
      expect(instance == 'jwt').to be true
      expect(instance == 'other').to be false
    end
  end
end
