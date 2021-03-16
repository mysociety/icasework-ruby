# frozen_string_literal: true

module Icasework
  ##
  # A Ruby representation of a case in iCasework
  #
  class Case
    class << self
      def where(params)
        Icasework::Resource.get_cases(params).data['Cases']['Case'].map do |d|
          new(
            'CaseDetails.CaseId' => d['CaseId'],
            'CaseDetails.CaseType' => d['Type'],
            'CaseDetails.CaseLabel' => d['Label'],
            'CaseStatusReceipt.Method' => d['RequestMethod'],
            'CaseStatusReceipt.TimeCreated' => d['RequestDate'],
            'CaseStatus.Status' => d['Status']
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
