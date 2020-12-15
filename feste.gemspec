# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'feste/version'

Gem::Specification.new do |spec|
  spec.name          = "feste"
  spec.version       = Feste::VERSION
  spec.authors       = ["Josh Reinhardt"]
  spec.email         = ["joshua.e.reinhardt@gmail.com"]

  spec.summary       = %q{Email subscription management for Rails applications.}
  spec.description   = %q{Give your users the ability to manage their email subscriptions in your Rails application.}
  spec.homepage      = "https://github.com/jereinhardt/feste"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.1"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "webdrivers", "~> 3.7", ">= 3.7.2"
  spec.add_development_dependency "capybara-selenium", "~> 0.0.6"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "devise"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "pg", "~> 0.18"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "shoulda-matchers"
end
