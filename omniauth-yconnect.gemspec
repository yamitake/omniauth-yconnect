# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-yconnect/version'

Gem::Specification.new do |gem|
  gem.name          = "omniauth-yconnect"
  gem.version       = Omniauth::Yconnect::VERSION
  gem.authors       = ["yamitake"]
  gem.email         = ["take.yapr@gmail.com"]
  gem.description   = %q{OmniAuth strategy for YConnect}
  gem.summary       = %q{OmniAuth strategy for YConnect}
  gem.homepage      = "https://github.com/yamitake/omniauth-yconnect"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'multi_json', '~> 1.3'
  gem.add_runtime_dependency 'omniauth-oauth', '~> 1.0'
  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
end
