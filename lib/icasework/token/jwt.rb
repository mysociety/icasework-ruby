# frozen_string_literal: true

require 'jwt'

module Icasework
  module Token
    ##
    # Generate JSON web token for OAuth API authentication
    #
    class JWT
      class << self
        def generate
          new ::JWT.encode(payload, Icasework.secret_key, 'HS256')
        end

        private

        def payload
          {
            iss: Icasework.api_key,
            aud: Icasework::Resource.token.url,
            iat: Time.now.to_i
          }
        end
      end

      def initialize(token)
        @token = token
      end

      def to_s
        @token
      end

      def ==(other)
        @token == other
      end
    end
  end
end
