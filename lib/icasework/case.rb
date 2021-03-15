# frozen_string_literal: true

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
              case_id: data['CaseId'],
              case_type: data['CaseType'],
              case_label: data['CaseLabel'],
              rating: data['Rating']
            }
          )
        end
      end

      def create(params)
        data = Icasework::Resource.create_case(params).data
        new(case_details: { case_id: data['createcaseresponse']['caseid'] })
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
