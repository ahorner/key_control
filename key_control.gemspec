# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'key_control/version'

Gem::Specification.new do |spec|
  spec.name          = "key_control"
  spec.version       = KeyControl::VERSION
  spec.authors       = ["Andrew Horner"]
  spec.email         = ["andrew@tablexi.com"]
  spec.summary       = "A simple wrapper for the `keyctl` utility."
  spec.description   = <<-TEXT
    Provides a Hash-like syntax for storing and retrieving data from the
    system's keyctl utility.
  TEXT

  spec.homepage      = "https://github.com/ahorner/key_control"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
