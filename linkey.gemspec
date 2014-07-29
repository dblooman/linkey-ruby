# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linkey/version'

Gem::Specification.new do |spec|
  spec.name          = 'linkey'
  spec.version       = Linkey::VERSION
  spec.authors       = ['Dave Blooman']
  spec.email         = ['david.blooman@gmail.com']
  spec.summary       = 'Linkey'
  spec.description   = 'Linkey'
  spec.homepage      = 'http://responsivenews.co.uk'
  spec.license       = 'Apache 2'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'parallel'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'typhoeus'
end
