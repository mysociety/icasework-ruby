# frozen_string_literal: true

require 'delegate'

module Icasework
  ##
  # A hash which will attempt to lazy load a value from given block when the key
  # is missing.
  #
  class LazyHash < SimpleDelegator
    def initialize(hash, key = nil, &block)
      @hash = hash
      @key = key
      @block = block

      @hash.default_proc = proc do |h, k|
        value = @block.call[@key].fetch(k) if @key
        value ||= @block.call.fetch(k)
        h[k] = value
      end

      super(@hash)
    end

    def [](key)
      value = @hash[key]
      case value
      when Hash
        LazyHash.new(value, key, &@block)
      else
        value
      end
    end
  end
end
