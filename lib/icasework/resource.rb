# frozen_string_literal: true

require 'rest_client'

module Icasework
  ##
  # API Endpoints for configured database
  #
  class Resource
    class << self
      def token(payload = {})
        resource('token', authorised: false).post(payload)
      end

      def get_cases(payload = {})
        resource('getcases', subdomain: 'uatportal').get(payload)
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

    attr_reader :method

    def initialize(uri:, options:)
      @resource = RestClient::Resource.new(uri, options)
    end

    def data
      response
    end

    def get(payload)
      @method = :get
      @payload = { params: payload }
      self
    end

    def post(payload)
      @method = :post
      @payload = payload
      self
    end

    private

    def response
      @resource.public_send(@method, @payload, &parser)
    rescue RestClient::Exception => e
      raise RequestError, e.message
    end

    def parser
      lambda do |response, _request, _result|
        JSON.parse(response.body)
      rescue JSON::ParserError
        raise ResponseError, "JSON invalid (#{response.body[0...100]})"
      end
    end
  end
end
