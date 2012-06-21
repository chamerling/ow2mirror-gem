# Ow2mirror::Gem

Mirror OW2 Gitorious repositories to Github.com organization

## Installation

Add this line to your application's Gemfile:

    gem 'ow2mirror-gem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ow2mirror-gem

## Configure

For now, this module clones public source repositories and push to authenticated repositories. It has been initially
developed to clone repositories from a gitorious instance running on OW2.org and push these repositories to Github.

As a limitation, user have to configure its system and git credentials according to the target system (github in the example).

## Usage

Ow2mirror comes with a binary used to create required resources and update repositories.

- 'ow2mirror install' : Creates all the required resources in the local folder
- 'ow2mirror create'  : Creates a new mirror (clone the source). This will ask you to give sources and destination informations
- 'ow2mirror mirror'  : Launches a mirror task which will get changes (fetch) from sources and put them (push) to destinations

### Create a workspace

Workspaces aggregates several mirrors which are potentially coming from different sources. The workspace stores project information, reports, logs, ...
You can create as many reports as needed acording to your usage. For example, the mirror command will got through all the projects, so creating multiple workspaces can be useful...

Command : 'ow2mirror new'

### Create a new mirror

Command : 'ow2mirror create'

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

Command : 'ow2mirror mirror'

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

## Limitations

TODO

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
