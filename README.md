# Ow2mirror::Gem

Mirror OW2 Gitorious repositories to Github.com organization

## Installation

Add this line to your application's Gemfile:

    gem 'ow2mirror-gem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ow2mirror-gem

## Usage

Ow2mirror comes with a binary used to create required resources and update repositories.

TODO

### Create a new mirror

ow2mirror create

This will get the projects and repositories from the source instance ask several questions:
 - <project> is the project name from the source instance
 - <repositories> a list of available repositories from the selected project
 - <target-prefix> is the target repository prefix name i.e. to differentiate the repositories in the organisation we need to prefix them.
    Short names are better as prefix...

The create task will create a <project> folder in the mirror folder and will clone all the required stuff. Add git remote and push things.
It also creates a JSON report file in this folder to keep traces: <project>.json

The create operation does the following git operations:

 1. Clone the source repository: 'git clone --bare --mirror REPO.git'
 2. Add the destination repository as remote 'git remote add github git@github.com:USER/REPO.git'

### Update a mirror

ow2mirror update

Will retrieve all the projects from the current runtime and call all the required git operation to pull from sources and push to destination.
It internally does the following git operations:

1. Fetch from source repository : git fetch --quiet origin
2. Push to destination repository : git push --quiet github

## Folders

The mirror engine stores git data and additional configuration files into folders. In order to run several mirrors on the same host, the structure is organized as:

- mirror.conf
  \_ project A
     \_ project.json
      _ repos.json
      _ repository 1
      _ repository 2
  \_ project B
     \_ project.json
      _ repos.json
      _ repository 1
      _ repository 2
      _ repository 3

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
