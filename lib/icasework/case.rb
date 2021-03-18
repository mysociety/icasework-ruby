# frozen_string_literal: true

require 'active_support/core_ext/hash/deep_merge'

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
            case_status_receipt: case_status_receipt_data(data),
            attributes: data[:attributes],
            classifications: Array(data[:classifications][:classification]),
            documents: Array(data[:documents][:document])
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

    def initialize(hash)
      @hash = LazyHash.new(hash) do
        load_additional_data!
      end
    end

    def case_id
      self[:case_details][:case_id]
    end

    def [](key)
      @hash[key]
    end

    def to_hash
      @hash
    end

    private

    def load_additional_data!
      return @hash if @loaded

      @loaded = true
      @hash.deep_merge!(fetch_additional_data)
    end

    def fetch_additional_data
      @fetch_additional_data ||= Icasework::Resource.get_case_details(
        case_id: case_id
      ).data[:cases][:case]
    end
  end
end
