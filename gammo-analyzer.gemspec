# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gammo_analyzer/version'

Gem::Specification.new do |spec|
  spec.name          = "gammo-analyzer"
  spec.version       = Gammo::Analyzer::VERSION
  spec.authors       = ["Richard Michael"]
  spec.email         = ["rmichael@edgeofthenet.org"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sqlite3"
  spec.add_runtime_dependency "sequel"
  spec.add_runtime_dependency "pry"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
