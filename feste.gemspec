# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'feste/version'

Gem::Specification.new do |spec|
  spec.name          = "feste"
  spec.version       = Feste::VERSION
  spec.authors       = ["Josh Reinhardt"]
  spec.email         = ["joshua.e.reinhardt@gmail.com"]

  spec.summary       = %q{Allow users to unsubscribe to your mailers; one-by-one or wholesale}
  spec.description   = %q{Allow users to unsubscribe to your mailers; one-by-one or wholesale}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rake"
  spec.add_dependency "activerecord"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "actionmailer"
  spec.add_development_dependency "activerecord-nulldb-adapter"
  spec.add_development_dependency "byebug"
end
