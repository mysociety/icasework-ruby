# frozen_string_literal: true

require 'active_support/core_ext/hash/conversions'

module Icasework
  ##
  # A patched version of ActiveSupport's XML converter which includes XML tag
  # attributes
  #
  # Credit: https://stackoverflow.com/a/29431089
  #
  class XMLConverter < ActiveSupport::XMLConverter
    private

    def become_content?(value)
      value['type'] == 'file' ||
        (value['__content__'] &&
         (value.keys.size == 1 && value['__content__'].present?))
    end
  end
end
