# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "gcevent"
  spec.version       = "0.0.1"
  spec.authors       = ["ogawatti"]
  spec.email         = ["ogawattim@gmail.com"]
  spec.summary       = %q{A wrapper of Google Calendar Event API.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/ogawatti/gcevent"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "google-api-client", "0.8.6"
  spec.add_dependency "activesupport"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
