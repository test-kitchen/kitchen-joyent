# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/driver/joyent_version'

Gem::Specification.new do |spec|
  spec.name          = 'kitchen-joyent'
  spec.version       = Kitchen::Driver::JOYENT_VERSION
  spec.authors       = ['Sean OMeara']
  spec.email         = ['someara@gmail.com']
  spec.description   = %q{A Test Kitchen Joyent driver}
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/someara/kitchen-joyent'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'test-kitchen', '~> 1.0'
  spec.add_dependency 'fog'

  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'countloc'
  spec.add_development_dependency 'rspec'
end
