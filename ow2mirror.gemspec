# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|

  gem.specification_version = 2 if gem.respond_to? :specification_version=
  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=
  gem.rubygems_version = '1.3.5'

  gem.authors       = ["Christophe Hamerling"]
  gem.email         = ["christophe.hamerling@ow2.org"]
  gem.description   = %q{Mirror Git repositories}
  gem.summary       = %q{Mirror Git repositories}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ow2mirror"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"

  gem.add_dependency('multi_json', "~> 1.0.3")

  # Nice HTTP client library
  gem.add_dependency('httparty', "~> 0.8.3")

  # Input stream management
  gem.add_dependency('highline', "~> 1.6.12")

  # XMLparsing (require xml)
  gem.add_dependency('libxml-ruby', "~> 2.3.2")

  # Mail
  gem.add_dependency('pony', "~> 1.4")

  gem.add_development_dependency('mocha', "~> 0.9.9")
  gem.add_development_dependency('rake', "~> 0.9.2")

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  # = MANIFEST =

end
