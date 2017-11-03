# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'firefox_cache2/version'

Gem::Specification.new do |spec|
  spec.name          = 'firefox_cache2'
  spec.version       = FirefoxCache2::VERSION
  spec.authors       = ['akira yamada']
  spec.email         = ['akira@arika.org']

  spec.summary       = 'Firefox cache2 entrr file utility'
  spec.homepage      = 'https://github.com/arika/firefox_cache2'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
end
