# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|

  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.authors       = ["Christophe Hamerling"]
  s.email         = ["christophe.hamerling@ow2.org"]
  s.description   = %q{Mirror Git repositories}
  s.summary       = %q{Mirror Git repositories}
  s.homepage      = ""

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.name          = "ow2mirror"
  s.require_paths = ["lib"]
  s.version       = "0.0.1"

  s.add_dependency('multi_json', "~> 1.0.3")

  # Nice HTTP client library
  s.add_dependency('httparty', "~> 0.8.3")

  # Input stream management
  s.add_dependency('highline', "~> 1.6.13")

  # XMLparsing (require xml)
  s.add_dependency('libxml-ruby', "~> 2.3.2")

  # Mail
  s.add_dependency('pony', "~> 1.4")

  s.add_development_dependency('mocha', "~> 0.9.9")
  s.add_development_dependency('rake', "~> 0.9.2")

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    Gemfile
    LICENSE
    README.md
    Rakefile
    bin/ow2mirror
    lib/ow2mirror.rb
    lib/ow2mirror/cli.rb
    lib/ow2mirror/client/client.rb
    lib/ow2mirror/client/file_client.rb
    lib/ow2mirror/client/github_client.rb
    lib/ow2mirror/client/gitorious_client.rb
    lib/ow2mirror/command.rb
    lib/ow2mirror/config.rb
    lib/ow2mirror/notifier/mail.rb
    lib/ow2mirror/notifier/notify.rb
    lib/ow2mirror/project.rb
    lib/ow2mirror/report.rb
    lib/ow2mirror/workspace.rb
    ow2mirror.gemspec
  ]
  # = MANIFEST =

end
