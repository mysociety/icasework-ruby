# frozen_string_literal: true

require 'active_support/core_ext/hash/deep_merge'

module Icasework
  ##
  # A Ruby representation of a case in iCasework
  #
  class Case
    class << self
      def where(params)
        cases = Icasework::Resource.get_cases(params).data[:cases]
        return [] unless cases

        [cases[:case]].flatten.map { |data| new(case_data(data)) }
      end

      def create(params)
        data = Icasework::Resource.create_case(params).data[:createcaseresponse]
        return nil unless data

        new(case_details: { case_id: data[:caseid] })
      end

      private

      def case_data(data)
        {
          case_details: case_details_data(data),
          case_status: case_status_data(data),
          case_status_receipt: case_status_receipt_data(data),
          attributes: data[:attributes],
          classifications: case_classifications_data(data),
          documents: case_documents_data(data)
        }
      end

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

      def case_classifications_data(data)
        return [] unless data[:classifications]

        [data[:classifications][:classification]].flatten
      end

      def case_documents_data(data)
        return [] unless data[:documents]

        [data[:documents][:document]].flatten
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

    def classifications
      @hash[:classifications].map { |c| Classification.new(c) }
    end

    def documents
      @hash[:documents].map { |d| Document.new(d) }
    end

    def to_h
      @hash.to_h
    end

    private

    def load_additional_data!
      return @hash if @loaded

      @loaded = true
      @hash.deep_merge!(fetch_additional_data)
    end

    def fetch_additional_data
      @fetch_additional_data ||= begin
        cases = Icasework::Resource.get_case_details(
          case_id: case_id
        ).data[:cases]

        if cases
          cases[:case]
        else
          {}
        end
      end
    end
  end
end
