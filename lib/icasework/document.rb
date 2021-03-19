# frozen_string_literal: true

module Icasework
  ##
  # A Ruby representation of a document in iCasework
  #
  class Document
    attr_reader :attributes, :url

    def initialize(attributes)
      @attributes = attributes
      @url = attributes[:__content__]
    end
  end
end
