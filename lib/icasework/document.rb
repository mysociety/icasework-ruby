# frozen_string_literal: true

module Icasework
  ##
  # A Ruby representation of a document in iCasework
  #
  class Document
    class << self
      def find(case_id:, document_id: nil)
        data = Icasework::Resource.get_case_documents(case_id: case_id).data
        documents = [data[:documents][:document]].flatten.map do |attributes|
          new(attributes)
        end

        return documents unless document_id

        documents.find { |d| d.attributes[:id] == document_id }
      end
    end

    attr_reader :attributes, :url

    def initialize(attributes)
      @attributes = attributes
      @url = attributes[:__content__]
    end
  end
end
