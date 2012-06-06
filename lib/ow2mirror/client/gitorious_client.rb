#
# Christophe Hamerling - ow2.org
#
require 'xml'
require 'csv'

module Ow2mirror
  module Client

    class GitoriousClient < Client

      #
      # initialize with a hash
      #
      def initialize(info)
        @url = info[:url]

        # Not used in current gitorious implementation
        @user = info[:username]
        @password = info[:password]

      end

      def load_data
        projects_xml = @url + "/projects.xml"
        @raw_xml = open(projects_xml).read
        @source = XML::Parser.string(@raw_xml)
        @content = @source.parse
      end

      #
      # Returns a list of project names
      #
      def projects
        if @content.nil?
          load_data
        end

        result = []

        projects = @content.root.find('./project')
        projects.each do |p|
          result << p.find_first('slug').content
        end
        result
      end

      #
      # Returns a table of hash of repositories like {:name => 'reponame', :giturl => 'repositorygiturl'}
      #
      def repositories(project)
        if @content.nil?
          load_data
        end

        result = []

        projects = @content.root.find('./project')
        projects.each do |p|
          if p.find_first('slug').content == project
            repositories = p.find_first('repositories')
            mainlines = repositories.find_first('mainlines')
            repos = mainlines.find('./repository')

            repos.each do |repo|
              name = repo.find_first('name').content
              url = giturl(project, name)
              result << {:name => name, :giturl => url}
            end
          end
        end
        result
      end

      #
      # Git URL of the project
      #
      def giturl(project, name)
        # Should find it from the API...
        # OW2 gitorious instance returns the wrong value, git protocol is not active, let's do it manually...
        # FIXME : Specific OW2 client implementation...
        "http://git.gitorious.ow2.org/#{project}/#{name}.git"
      end

      #
      # Create a remote repository
      #
      def create(project, name)
        puts "Create is not available in the Gitorious API"
      end

    end


  end
end
