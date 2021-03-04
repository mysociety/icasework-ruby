# frozen_string_literal: true

module Icasework
  module Token
    ##
    # Generate access token for Bearer authorisation header
    #
    class Bearer
      class << self
        def generate
          new Icasework::Resource.token.post(payload)
        rescue RestClient::Exception
          raise AuthenticationError
        end

        private

        def payload
          {
            grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            assertion: Icasework::Token::JWT.generate
          }
        end
      end

      def initialize(response)
        data = JSON.parse(response.body)
        @access_token = data.fetch('access_token')
        @token_type = data.fetch('token_type')
        @expires_in = data.fetch('expires_in')
      rescue JSON::ParserError
        raise AuthenticationError
      end

      def to_s
        @access_token
      end
    end
  end
end
