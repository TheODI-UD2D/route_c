# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'route_c/version'

Gem::Specification.new do |spec|
  spec.name          = 'route_c'
  spec.version       = RouteC::VERSION
  spec.authors       = ['pikesley', 'pezholio']
  spec.email         = ['ops@theodi.org']

  spec.summary       = %q{words}
  spec.description   = %q{words}
  spec.homepage      = 'http://github.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'coveralls', '~>0.8'
  spec.add_development_dependency 'timecop', '~> 0.8'
end
