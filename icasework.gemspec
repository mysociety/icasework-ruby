# frozen_string_literal: true

require_relative 'lib/icasework/version'

Gem::Specification.new do |spec|
  spec.name          = 'icasework'
  spec.version       = Icasework::VERSION
  spec.authors       = ['mySociety']
  spec.email         = ['hello@mysociety.org']

  spec.summary       = 'Ruby library for the iCasework API.'
  spec.description   = 'iCasework is a case management software that enables ' \
    'organisations of all sizes to do a better job of case management'
  spec.homepage      = 'https://github.com/mysociety/icasework-ruby/'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.0.0', '< 8.1'
  spec.add_dependency 'jwt', '~> 2.2.0'
  spec.add_dependency 'nokogiri', '~> 1.0'
  spec.add_dependency 'pdf-reader', '~> 2.4.0'
  spec.add_dependency 'rest-client', '~> 2.1.0'
  spec.add_dependency 'rexml', '~> 3.4.0'
end
