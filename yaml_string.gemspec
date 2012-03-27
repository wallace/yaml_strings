# -*- encoding: utf-8 -*-
require File.expand_path('../lib/yaml_string/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jonathan R. Wallace"]
  gem.email         = ["jonathan.wallace@gmail.com"]
  gem.description   = %q{Convert YAML files to .string format and vice versa.}
  gem.summary       = %q{Converts a YAML file, specifically the ones typically used for locale and translations in Rails, to an old style Apple ASCII Property List, http://bit.ly/old_style_ascii_property_list}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "yaml_string"
  gem.require_paths = ["lib"]
  gem.version       = YamlString::VERSION
end
