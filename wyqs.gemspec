# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wyqs/version'

Gem::Specification.new do |gem|
  gem.name          = "wyqs"
  gem.version       = Wyqs::VERSION
  gem.authors       = ["aoner"]
  gem.email         = ["aoners@gmail.com"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  s.add_dependency('json', '~>1.6')
  gem.require_paths = ["lib"] 
end
