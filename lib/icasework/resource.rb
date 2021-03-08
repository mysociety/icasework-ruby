# frozen_string_literal: true

require 'rest_client'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/hash/keys'

module Icasework
  ##
  # API Endpoints for configured database
  #
  class Resource
    class << self
      def token(payload = {})
        resource('token', authorised: false, include_format: false).
          post(payload)
      end

      def get_cases(payload = {})
        resource('getcases', subdomain: 'uatportal').get(payload)
      end

      def get_case_attribute(payload = {})
        resource('getcaseattribute').get(payload)
      end

      def get_case_details(payload = {})
        resource('getcasedetails').get(payload)
      end

      def get_case_documents(payload = {})
        resource('getcasedocuments').get(payload)
      end

      def create_case(payload = {})
        resource('createcase').post(payload)
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
      @include_format = options.delete(:include_format) { true }
      @resource = RestClient::Resource.new(uri, options)
    end

    def data
      response
    end

    def get(payload)
      @method = :get
      @payload = { params: prepare_payload(payload) }
      self
    end

    def post(payload)
      @method = :post
      @payload = prepare_payload(payload)
      self
    end

    private

    def response
      @resource.public_send(@method, @payload, &parser)
    rescue RestClient::Exception => e
      raise RequestError, e.message
    end

    def prepare_payload(payload)
      return unless payload

      # TODO: handle array values, map keys suffixed with integers
      payload[:format] = 'json' if @include_format
      payload.transform_keys! do |k|
        next k if valid_keys.include?(k.to_s)

        ActiveSupport::Inflector.classify(k)
      end

      payload
    end

    # these params keys should remain as they are, no need to classify-case them
    def valid_keys
      %w[db fromseq toseq grant_type assertion access_token]
    end

    def parser
      lambda do |response, _request, _result|
        process_data(JSON.parse(response.body))
      rescue JSON::ParserError
        raise ResponseError, "JSON invalid (#{response.body[0...100]})"
      end
    end

    def process_data(data)
      case data
      when Hash
        data.deep_transform_keys! do |key|
          # TODO: handle keys suffixed with integers, map to arrays
          # TODO: handle keys with periods, map to hashes
          key.underscore.to_sym
        end
      when Array
        data.map { |d| process_data(d) }
      else
        data
      end
    end
  end
end
