#
# Christophe Hamerling - OW2
#
# A project is used to create and access mirror resources, git repositories and really mirror them...
# It contains all the information about source and destination systems (endpoint, credentials, ...)
#
require 'pp'

module Ow2mirror
  class Project

    include FileUtils

    # Contains the list of repositories which has been mirrored
    REPOS_FILE_NAME = "repos.json"

    # Contains all the project information
    PROJECT_FILE_NAME = "project.json"

    #
    #
    #
    def initialize(workspace, name)
      fail 'Need to provide the project name' if name.nil?

      @workspace = workspace
      @name = name
      @root_folder = workspace.project_folder(@name)

      load_attributes if File.exists?(project_file)
    end

    #
    # Create the attributes with default values
    #
    def default_attributes
      @attributes = {
          :project => @name,
          :prefix => @prefix,
          :repositories => @repositories,
          :source => @source_project,
          :target => @target_project,
          :creation_date => "#{Time.now}",
          :last_mirror => "0",
          :date => "#{Time.now}",
      }
    end

    #
    # Create all the required resources for a project
    #
    def create(source_project, target_project, prefix = '', repositories='*')
      fail 'Source project should not be null' if source_project.nil?
      fail 'Target project should not be null' if target_project.nil?

      @prefix = prefix
      @repositories = repositories
      @source_project = source_project
      @target_project = target_project

      puts "Creating the project with prefix '#{prefix}', repositories '#{repositories}', source project '#{source_project}' and target project '#{target_project}'"

      bootstrap unless File.directory?(folder) and File.exists?(project_file)
      load_attributes

      pp @attributes
    end

    #
    # Creates the default project folder with all the required files
    #
    def bootstrap
      puts "Creating folder for project at #{folder}"
      mkdir_p folder
      default_attributes
      save
    end

    #
    # Returns the project folder path
    #
    def folder
      @root_folder
    end

    #
    # Folder for the given repository name. We clone the source repository into a REPO.git folder
    #
    def repository_folder(repo_name)
      File.join(folder, "#{repo_name}.git")
    end

    #
    # Project configuration file
    #
    def project_file
      File.join(folder, PROJECT_FILE_NAME)
    end

    #
    # Cache the repositories list into a JSON file
    #
    def repos_file
      File.join(folder, REPOS_FILE_NAME)
    end

    #
    # Really create the mirror:
    # Get the configuration attributes, clone source repositories and push them to their destination.
    #
    def create_mirror
      puts "## Create mirror for project #{@name}"
      # TODO : Check that all required data is here!
      load_attributes

      @config = Ow2mirror::Config.new(@workspace, @name)
      @config.load_attributes

      puts "Attributes : "
      pp @attributes

      puts "Configuration : "
      pp @config

      puts ">> Mirroring stuff from #{@source_project} source project to #{@target_project}..."
      cd(folder)

      puts " - Working in the folder #{pwd}"

      # Get the repositories with their name and gitorious git URL
      # TODO :Make it in a generic way (load class from name)...

      source = {}
      source[:username] = @config.attributes['source']['username']
      source[:password] = @config.attributes['source']['password']
      source[:url] = @config.attributes['source']['url']
      source[:project] = @attributes['source']
      source_client = Ow2mirror::Client::GitoriousClient.new(source)
      sources = source_client.repositories(@source_project)

      target = {}
      target[:username] = @config.attributes['destination']['username']
      target[:password] = @config.attributes['destination']['password']
      target[:url] = @config.attributes['destination']['url']
      target[:project] = @attributes['target']
      target_client = Ow2mirror::Client::GithubClient.new(target)

      puts " - Retrieved the following repositories from sources"
      sources.each do |repository|
        puts "  - #{repository[:name]} @ #{repository[:giturl]}"
      end

      repos = []

      # For each repository, create the new one on the destination host
      # TODO : Filter from user choices...
      sources.each do |repository|
        cd(folder)
        puts " - Working in the folder #{pwd}"

        name = repository[:name]
        git = repository[:giturl]

        puts " - Working on repository #{name} - #{git}"
        puts " - Clone source locally into #{name}"

        Ow2mirror::Command.git("clone --bare --mirror #{git}")

        folder = repository_folder(name)

        puts " - cd to #{folder}"
        if File.directory?(repository_folder(repository)) and File.exist?(repository_folder(repository))
          # No folder means that something failed...
        end

        cd(folder)

        target_repo = (@prefix.nil? or @prefix.empty?) ? name : "#{@prefix}-#{name}"

        puts " - Target repository is #{target_repo}"

        remote = target_client.create(@attributes['target'], target_repo, "Official mirror of OW2 repository #{name} hosted at #{git}")
        Ow2mirror::Command.git("remote add #{@config.attributes['destination']['type']} #{remote}")

        Ow2mirror::Command.git("config remote.#{@config.attributes['destination']['type']}.mirror true")

        # cache repo
        repos << {:name => name, :source => git, :destination => remote}

      end

      puts ">>> Generated repositories"
      pp repos

      save
      save_repos repos

      @workspace.add_project(@name)

      mirror
    end

    #
    # Mirror all the repositories based on the mirror file generated by the create_mirror method
    #
    def mirror
      @config = Ow2mirror::Config.new(@workspace, @name)
      @config.load_attributes

      puts "- Mirroring repositories for project #{@name}..."
      repositories.each do |repository|
        puts "Mirroring repository #{repository}..."
        mirror_repository(repository['name'])
      end
    end


    #
    # Get all the repositories of the current project
    #
    def repositories
      # TODO : merge with current data
      load_repos
    end

    #
    #
    #
    def mirror_repository(repository_name)
      if File.directory?(repository_folder(repository_name)) and File.exist?(repository_folder(repository_name))
        puts "> cd #{repository_folder(repository_name)}"
        cd(repository_folder(repository_name))

        Ow2mirror::Command.git("fetch --quiet origin")
        Ow2mirror::Command.git("push --quiet #{@config.attributes['destination']['type']}")
      else
        puts "#{repository_name} is not valid : Folder not found!"
      end
    end

    #
    # Load the attributes from the configuration file
    #
    def load_attributes
      puts "Loading project information from #{project_file}"
      @attributes = MultiJson.decode(File.new(project_file, 'r').read)
    end

    def required_creation_data!
      @target_project != nil and @target_project.length > 0 and @name != nil and @name.length > 0
    end

    def required_mirroring_data!
      @name != nil and @name.length > 0
    end

    #
    # Save the project information in the project folder
    #
    def save
      puts "Saving project information to #{project_file}"
      json = MultiJson.encode(@attributes)
      File.open(project_file, 'w') { |f| f.write(json) }
    end

    #
    # Load the repos from file
    #
    def load_repos
      MultiJson.decode(File.new(repos_file, 'r').read)
    end

    #
    # Save the repos table to file
    #
    def save_repos(repos)
      json = MultiJson.encode(repos)
      File.open(repos_file, 'w') { |f| f.write(json) }
    end

  end
end

