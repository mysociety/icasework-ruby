# frozen_string_literal: true

module Icasework
  ##
  # A Ruby representation of a case in iCasework
  #
  class Case
    class << self
      def where(params)
        Icasework::Resource.get_cases(params).data[:cases][:case].map do |data|
          new(
            case_details: case_details_data(data),
            case_status: case_status_data(data),
            case_status_receipt: case_status_receipt_data(data)
          )
        end
      end

      def create(params)
        data = Icasework::Resource.create_case(params).data
        new(
          case_details: {
            case_id: data[:createcaseresponse][:caseid]
          }
        )
      end

      private

      def case_details_data(data)
        { case_id: data[:case_id], case_type: data[:type],
          case_label: data[:label] }
      end

      def case_status_receipt_data(data)
        { method: data[:request_method], time_created: data[:request_date] }
      end

      def case_status_data(data)
        { status: data[:status] }
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
