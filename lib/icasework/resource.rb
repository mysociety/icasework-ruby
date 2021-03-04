# frozen_string_literal: true

require 'rest_client'

module Icasework
  ##
  # API Endpoints for configured database
  #
  class Resource
    class << self
      def token
        resource('token')
      end

      private

      def resource(path, subdomain: 'uat')
        new(uri: uri(path: path, subdomain: subdomain))
      end

      def uri(path:, subdomain:)
        if Icasework.production?
          "https://#{Icasework.account}.icasework.com/#{path}"
        else
          "https://#{subdomain}.icasework.com/#{path}?db=#{Icasework.account}"
        end
      end
    end

    extend Forwardable
    def_delegator :@resource, :url

    def initialize(uri:)
      @resource = RestClient::Resource.new(uri)
    end
  end
end
