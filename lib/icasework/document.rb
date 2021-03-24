# frozen_string_literal: true

require 'pdf/reader'

module Icasework
  ##
  # A Ruby representation of a document in iCasework
  #
  class Document
    class << self
      def where(params)
        documents = Icasework::Resource.get_case_documents(params).
                    data[:documents]
        return [] unless documents

        [documents[:document]].flatten.map do |attributes|
          new(attributes)
        end
      end

      def find(document_id: nil, **params)
        documents = where(params)
        return documents unless document_id

        documents.find { |d| d.attributes[:id] == document_id }
      end
    end

    attr_reader :attributes, :url

    def initialize(attributes)
      @attributes = attributes
      @url = attributes[:__content__]
    end

    def pdf?
      attributes[:type] == 'application/pdf'
    end

    def pdf_contents
      return unless pdf?

      PDF::Reader.open(pdf_file) do |reader|
        reader.pages.map(&:text).join
      end
    end

    private

    def pdf_file
      raw = RestClient::Request.execute(
        method: :get,
        url: url,
        raw_response: true
      )
      raw.file
    end
  end
end
