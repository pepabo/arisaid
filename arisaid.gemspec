# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arisaid/version'

Gem::Specification.new do |spec|
  spec.name          = "arisaid"
  spec.version       = Arisaid::VERSION
  spec.authors       = ["linyows"]
  spec.email         = ["linyows@gmail.com"]

  spec.summary       = %q{Slack configuration.}
  spec.description   = %q{Configure the slack by yaml files.}
  spec.homepage      = "https://github.com/pepabo/arisaid"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "breacan", "~> 0.9"
  spec.add_dependency "thor"
  spec.add_dependency "pit"
  spec.add_dependency "colorize"

  spec.add_development_dependency "bundler", ">= 1.10"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "minitest"
end
