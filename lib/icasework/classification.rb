# frozen_string_literal: true

module Icasework
  ##
  # A Ruby representation of a classification in iCasework
  #
  class Classification
    attr_reader :group, :title

    def initialize(attributes)
      @group = attributes[:group]
      @title = attributes[:__content__]
    end
  end
end
