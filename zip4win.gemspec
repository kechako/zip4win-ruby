# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zip4win/version'

Gem::Specification.new do |spec|
  spec.name          = "zip4win"
  spec.version       = Zip4win::VERSION
  spec.authors       = ["Ryosuke Akiyama"]
  spec.email         = ["ryosuke.akiyama@broadleaf.co.jp"]
  spec.summary       = %q{Create zip archive for Windows.}
  spec.description   = %q{Create zip archive for Windows.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rubyzip"
  spec.add_runtime_dependency "unf"
  
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
