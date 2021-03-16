# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::Resource::Data do
  describe '.process' do
    subject { described_class.process(data) }

    let(:data) do
      {
        'Cases' => {
          'Case' => {
            'CaseDetails.CaseId' => 123,
            'Event1.Foo' => 'Foo 1',
            'Event1.Bar' => 'Bar 1',
            'Event2.Foo' => 'Foo 2',
            'Event2.Bar' => 'Bar 2',
            'Keyword1' => 'foo',
            'Keyword2' => 'bar',
            'Object1' => { foo: 'Foo' },
            'Object2' => { bar: 'Bar' }
          }
        }
      }
    end

    let(:converted) do
      {
        cases: {
          case: {
            case_details: { case_id: 123 },
            event: [
              { foo: 'Foo 1', bar: 'Bar 1' },
              { foo: 'Foo 2', bar: 'Bar 2' }
            ],
            keyword: %w[foo bar],
            object: [
              { foo: 'Foo' },
              { bar: 'Bar' }
            ]
          }
        }
      }
    end

    it { is_expected.to eq(converted) }
  end
end
