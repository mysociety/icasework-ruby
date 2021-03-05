# frozen_string_literal: true

module Icasework
  ##
  # An API authentication error
  #
  AuthenticationError = Class.new(RuntimeError)

  ##
  # A request error
  #
  RequestError = Class.new(RuntimeError)

  ##
  # A response error
  #
  ResponseError = Class.new(RuntimeError)
end
