# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linky/version'

Gem::Specification.new do |spec|
  spec.name          = "linky"
  spec.version       = Linky::VERSION
  spec.authors       = ["Dave Blooman"]
  spec.email         = ["david.blooman@gmail.com"]
  spec.summary       = 'Linky'
  spec.description   = 'Linky'
  spec.homepage      = "http://responsivenews.co.uk"
  spec.license       = "Apache 2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor"
end
