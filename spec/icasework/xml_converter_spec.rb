# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Icasework::XMLConverter do
  let(:instance) { described_class.new(xml) }

  let(:xml) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <Documents>
        <Document Id="D123" Name="Response (some not held)" Category="General upload" Type="application/pdf" Source="Document" DocumentDate="2021-03-01T00:00:00"><![CDATA[https://example.com/file.pdf]]></Document>
      </Documents>
    XML
  end

  describe '#to_h' do
    subject(:hash) { instance.to_h }

    let(:expected) do
      {
        'Documents' => {
          'Document' => {
            'Category' => 'General upload',
            'DocumentDate' => '2021-03-01T00:00:00',
            'Id' => 'D123',
            'Name' => 'Response (some not held)',
            'Source' => 'Document',
            'Type' => 'application/pdf',
            '__content__' => 'https://example.com/file.pdf'
          }
        }
      }
    end

    it 'converts XML into Ruby hash with tag attributes' do
      expect(hash).to eq expected
    end
  end
end
