# frozen_string_literal: true

require 'active_support/core_ext/hash/deep_merge'

module Icasework
  ##
  # A Ruby representation of a case in iCasework
  #
  class Case
    class << self
      def where(params)
        Icasework::Resource.get_cases(params).data.map do |data|
          new(
            case_details: {
              case_id: data[:case_id], case_type: data[:case_type],
              case_label: data[:case_label], rating: data[:rating]
            }
          )
        end
      end

      def create(params)
        data = Icasework::Resource.create_case(params).data
        new(case_details: { case_id: data[:createcaseresponse][:caseid] })
      end
    end

    def initialize(data)
      @data = data
    end

    def case_id
      @data[:case_details][:case_id]
    end
  end
end
