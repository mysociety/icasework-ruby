# frozen_string_literal: true

module Icasework
  class Resource
    ##
    # Method to output a Icasework::Resource instance as a curl command:
    #
    module Curl
      def to_curl
        "curl #{curl_params}#{curl_auth}'#{url}'"
      end

      private

      def curl_auth
        auth_header = headers[:authorization]
        "-H 'Authorization: #{auth_header}' " if auth_header
      end

      def curl_params
        case method
        when :get
          return '-X GET ' if payload[:params].empty?

          "-G -d '#{URI.encode_www_form(payload[:params])}' "
        when :post
          return '-X POST ' if payload.empty?

          "-X POST -d '#{URI.encode_www_form(payload)}' "
        end
      end
    end
  end
end
