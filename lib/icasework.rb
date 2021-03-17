# frozen_string_literal: true

require 'icasework/version'

##
# This module is the main entry point of the Gem
#
module Icasework
  require 'icasework/case'
  require 'icasework/errors'
  require 'icasework/lazy_hash'
  require 'icasework/resource'
  require 'icasework/resource/data'
  require 'icasework/resource/payload'
  require 'icasework/token/jwt'
  require 'icasework/token/bearer'

  ConfigurationError = Class.new(StandardError)

  class << self
    attr_writer :account, :api_key, :secret_key

    def account
      @account || raise(
        ConfigurationError, 'Icasework.account not configured'
      )
    end

    def api_key
      @api_key || raise(
        ConfigurationError, 'Icasework.api_key not configured'
      )
    end

    def secret_key
      @secret_key || raise(
        ConfigurationError, 'Icasework.secret_key not configured'
      )
    end

    def env=(env)
      @production = (env == 'production')
    end

    def production?
      @production || false
    end
  end
end
