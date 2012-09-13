# -*- encoding: utf-8 -*-
require File.expand_path('../lib/refreshingmenus_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joost Hietbrink"]
  gem.email         = ["joost@joopp.com"]
  gem.description   = %q{Ruby API to use the Refreshing Menus REST API.}
  gem.summary       = %q{Ruby API to use the Refreshing Menus REST API.}
  gem.homepage      = "http://www.refreshingmenus.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "refreshingmenus_api"
  gem.require_paths = ["lib"]
  gem.version       = RefreshingmenusApi::VERSION

  gem.add_dependency('httparty')
  gem.add_dependency('activesupport')
end
