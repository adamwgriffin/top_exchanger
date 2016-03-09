# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'top_exchanger/version'

Gem::Specification.new do |spec|
  spec.name          = "top_exchanger"
  spec.version       = TopExchanger::VERSION
  spec.authors       = ["Adam Griffin"]
  spec.email         = ["adam.griffin@moxiworks.com"]
  spec.summary       = %q{Translate Top Producer export files to Office 365 format.}
  spec.description   = %q{Parses a Top Producer CSV export file and maps the appropriate fields to a new CSV.}
  spec.homepage      = "https://github.com/adamwgriffin"
  spec.license       = "All Your Base Are Belong to Us"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'pry-debugger', '~> 0'
  spec.add_runtime_dependency 'activesupport', '~> 4.1', '>= 4.1.8'
end
