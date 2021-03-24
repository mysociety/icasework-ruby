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
        new_hash = @block.call
        new_hash = new_hash[@key] if @key
        h[k] = new_hash.fetch(k, nil)
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
