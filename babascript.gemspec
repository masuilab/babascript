# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'babascript/version'

Gem::Specification.new do |spec|
  spec.name          = "babascript"
  spec.version       = BabaScript::VERSION
  spec.authors       = ["Sho Hashimoto", "Takumi Baba"]
  spec.email         = ["hashimoto@shokai.org", "contact@mail.takumibaba.com"]
  spec.description   = %q{BabaScript is a script launguage which runs on @takumibaba}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/masuilab/babascript"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject{|i| i=="Gemfile.lock" }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "em-rocketio-linda-client", "~> 1.0"
  spec.add_dependency "json"
  spec.add_dependency "args_parser"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
