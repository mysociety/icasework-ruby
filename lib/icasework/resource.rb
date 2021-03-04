# frozen_string_literal: true

require 'rest_client'

module Icasework
  ##
  # API Endpoints for configured database
  #
  class Resource
    class << self
      def token
        resource('token', authorised: false)
      end

      def get_cases
        resource('getcases', subdomain: 'uatportal')
      end

      private

      def resource(path, authorised: true, subdomain: 'uat', **options)
        if authorised
          options[:headers] = {
            authorization: "Bearer #{Icasework::Token::Bearer.generate}"
          }
        end

        new(uri: uri(path: path, subdomain: subdomain), options: options)
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
    def_delegators :@resource, :url, :headers
    def_delegators :@resource, :get, :post

    def initialize(uri:, options:)
      @resource = RestClient::Resource.new(uri, options)
    end
  end
end
