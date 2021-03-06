# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nested_strong_parameters/version'

Gem::Specification.new do |spec|
  spec.name          = "nested_strong_parameters"
  spec.version       = NestedStrongParameters::VERSION
  spec.authors       = ["Alejandro Babio\n"]
  spec.email         = ["alejandro.e.babio@hotmail.com"]
  spec.summary       = %q{Make simple the use of nested_attributes with strong_parameters}
  spec.description   = %q{Make simple the use of nested_attributes with strong_parameters}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 4.0"
  spec.add_dependency "activesupport", "~> 4.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 4.7"
end
