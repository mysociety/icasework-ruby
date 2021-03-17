# frozen_string_literal: true

module Icasework
  class Resource
    ##
    # Converts payload for iCasework API endpoints into a flat/titlecase keys
    #
    module Payload
      class << self
        def process(data)
          case data
          when Hash
            nested_to_flat_keys(convert_keys(data))
          else
            data
          end
        end

        private

        # converts { 'foo' => { 'bar' => 'baz' } }
        # into: { 'foo.bar' => 'baz' }
        def nested_to_flat_keys(hash, key = [])
          return { key.join('.') => process(hash) } unless hash.is_a?(Hash)

          hash.inject({}) do |h, v|
            h.merge!(nested_to_flat_keys(v[-1], key + [v[0]]))
          end
        end

        # converts: :foo_bar
        # into: 'FooBar'
        def convert_keys(hash)
          hash.each_with_object({}) do |(key, value), all|
            converted_key = key if valid_keys.include?(key.to_s)
            converted_key ||= key.to_s.gsub(/(?:^|_)([a-z])/i) do
              Regexp.last_match(1).upcase
            end

            all[converted_key.to_s] = process(value)
          end
        end

        def valid_keys
          %w[db fromseq toseq grant_type assertion access_token]
        end
      end
    end
  end
end
