# frozen_string_literal: true

require 'bundler/setup'
require 'icasework'

include Icasework

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Icasework.account = 'test'
    Icasework.api_key = 'foo'
    Icasework.secret_key = 'bar'
    Icasework.mode = :test
  end
end
