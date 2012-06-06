#
# Christophe Hamerling - ow2.org
#
module Ow2mirror
  module Client


    class GithubClient < Client

      #
      # intialize with a hash
      #
      def initialize(info)

        @user = info[:username]
        @password = info[:password]

        begin
          require 'httparty'

          self.class.send(:include, HTTParty)
          self.class.base_uri "https://api.github.com"
        rescue LoadError
          puts "The Gist backend requires HTTParty: gem install httparty"
          exit
        end

        self.class.basic_auth(@user, @password)

      end

      def repositories(project)
        # TODO
      end

      #
      # Create the repository and get back the git URL
      #
      def create(project_name, repo_name, description)
        puts "Create repository #{repo_name} in org #{project_name}"

        response = self.class.post("/orgs/#{project_name}/repos", request_params(repo_name, description))
        puts "Github response : #{response}"
        # TODO : Test the HTTP status code, 200 means that creation is OK
        # TODO : get me from the github API response
        giturl(project_name, repo_name)
      end

      def giturl(project, name)
        "git@github.com:#{project}/#{name}.git"
      end

      def request_params(repo_name, description)
        {
            :body =>
                MultiJson.encode({
                                     :name => repo_name,
                                     :description => description,
                                     :homepage => "http://ow2.org",
                                     :private => false,
                                     :has_issues => false,
                                     :has_wiki => false,
                                     :has_downloads => false
                                 })
        }
      end

    end

  end

end