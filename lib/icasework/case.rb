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
            'CaseDetails.CaseId' => data['CaseId'],
            'CaseDetails.CaseType' => data['CaseType'],
            'CaseDetails.CaseLabel' => data['CaseLabel'],
            'CaseDetails.Rating' => data['Rating']
          )
        end
      end

      def create(params)
        data = Icasework::Resource.create_case(params).data
        new('CaseDetails.CaseId' => data['createcaseresponse']['caseid'])
      end
    end

    def initialize(data)
      @data = data
    end

    def case_id
      @data['CaseDetails.CaseId']
    end
  end
end
