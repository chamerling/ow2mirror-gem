#
# Christophe Hamerling - ow2.org
#
module Ow2mirror
  module Client

    class Client

      #
      # Get a hash of repositories. Repo name as key, git URL as value
      #
      def repositories(project) ; end

      #
      # Get the available projects
      #
      def projects ; end

      #
      # Create a repository on the remote system
      # project_name : The name of the project the repository belongs to (organisation name for github)
      # repo_name : The name of the created repository
      # description : A repository description
      #
      def create(project_name, repo_name, description) ; end

      #
      # Get the git URL
      #
      def giturl(project_name, repo_name) ; end

    end
  end
end
