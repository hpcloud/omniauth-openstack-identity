# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-openstack-identity/version'

Gem::Specification.new do |s|
  s.name          = "omniauth-openstack-identity"
  s.version       = Omniauth::OpenstackIdentity::VERSION
  s.authors       = ["Chris Johnson"]
  s.email         = ["wchrisjohnson@gmail.com"]
  s.summary       = %q{OmniAuth strategy for Openstack Identity (keystone).}
  s.description   = %q{OmniAuth strategy for Openstack Identity (keystone).}
  s.homepage      = "https://github.com/wchrisjohnson/omniauth-openstack-identity"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'omniauth', '~> 1.0'
  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'
  s.add_development_dependency 'rspec', '~> 2.7'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
end
