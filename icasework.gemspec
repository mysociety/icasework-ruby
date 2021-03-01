require_relative 'lib/icasework/version'

Gem::Specification.new do |spec|
  spec.name          = "icasework"
  spec.version       = Icasework::VERSION
  spec.authors       = ["mySociety"]
  spec.email         = ["hello@mysocity.org"]

  spec.summary       = %q{Ruby library for the iCasework API.}
  spec.description   = %q{iCasework is a case management software that enables organisations of all sizes to do a better job of case management}
  spec.homepage      = "https://github.com/mysociety/icasework-ruby/"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
