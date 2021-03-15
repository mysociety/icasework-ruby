# frozen_string_literal: true

require 'rest_client'

module Icasework
  ##
  # API Endpoints for configured database
  #
  class Resource
    class << self
      def token(payload = {})
        new(:post, 'token', payload, authorised: false, format: nil)
      end

      def get_cases(payload = {})
        new(:get, 'getcases', payload, subdomain: 'uatportal')
      end

      def get_case_attribute(payload = {})
        new(:get, 'getcaseattribute', payload)
      end

      def get_case_details(payload = {})
        new(:get, 'getcasedetails', payload)
      end

      def get_case_documents(payload = {})
        new(:get, 'getcasedocuments', payload)
      end

      def create_case(payload = {})
        new(:post, 'createcase', payload)
      end
    end

    attr_reader :method

    def initialize(method, path, payload, **options)
      @method = method
      @path = path
      @payload = payload
      @options = options
    end

    def url
      if Icasework.production?
        "https://#{Icasework.account}.icasework.com/#{@path}"
      else
        subdomain = @options.fetch(:subdomain, 'uat')
        "https://#{subdomain}.icasework.com/#{@path}?db=#{Icasework.account}"
      end
    end

    def headers
      return {} unless authorised?

      headers = {}
      headers[:authorization] = "Bearer #{Icasework::Token::Bearer.generate}"
      headers
    end

    def payload
      return @payload if @payload_parsed

      @payload[:Format] = format if format

      @payload = { params: @payload } if method == :get

      @payload_parsed = true
      @payload
    end

    def data
      response
    end

    private

    def authorised?
      @options.fetch(:authorised, true)
    end

    def format
      @options.fetch(:format, 'json')
    end

    def resource
      RestClient::Resource.new(url, headers: headers)
    end

    def response
      resource.public_send(method, payload, &parser)
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
