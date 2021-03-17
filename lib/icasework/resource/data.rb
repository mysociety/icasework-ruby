# frozen_string_literal: true

module Icasework
  class Resource
    ##
    # Converts data returned from the iCasework API into a more "Ruby like" hash
    #
    module Data
      class << self
        def process(data)
          case data
          when Hash
            convert_keys(array_keys_to_array(flat_keys_to_nested(data)))
          when Array
            data.map { |d| process(d) }
          else
            data
          end
        end

        private

        # converts: { 'foo.bar': 'baz' }
        # into { foo: { bar: 'baz' } }
        def flat_keys_to_nested(hash)
          hash.each_with_object({}) do |(key, value), all|
            key_parts = key.to_s.split('.')
            leaf = key_parts[0...-1].inject(all) { |h, k| h[k] ||= {} }
            leaf[key_parts.last] = process(value)
          end
        end

        # converts: { 'n1': 'foo', 'n2': 'bar' }
        # into: { n: ['foo', 'bar'] }
        def array_keys_to_array(hash)
          hash.each_with_object({}) do |(key, value), all|
            if key.to_s =~ /^(.*)\d+$/
              key = Regexp.last_match(1)
              all[key] ||= []
              all[key] << process(value)
            else
              all[key] = process(value)
            end
          end
        end

        # converts: 'FooBar'
        # into: :foo_bar
        def convert_keys(hash)
          hash.each_with_object({}) do |(key, value), all|
            converted_key = key.gsub(/([a-z\d])?([A-Z])/) do
              first = Regexp.last_match(1)
              second = Regexp.last_match(2)
              "#{"#{first}_" if first}#{second.downcase}"
            end

            all[converted_key.to_sym] = process(value)
          end
        end
      end
    end
  end
end
