# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keynote/version'

Gem::Specification.new do |spec|
  spec.name          = "keynote-client"
  spec.version       = Keynote::Client::VERSION
  spec.authors       = ["ryo katsuma"]
  spec.email         = ["katsuma@gmail.com"]
  spec.summary       = %q{keynote client with high level API.}
  spec.description   = %q{keynote-client provides a high level API like ActiveRecord style to control your Keynote.}
  spec.homepage      = "https://github.com/katsuma/keynote-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency "unindent", "~> 1.0"
  spec.add_development_dependency "pry"
end
