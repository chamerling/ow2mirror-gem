#
# Christophe Hamerling - ow2.org
#
# The project level configuration
#
module Ow2mirror
  class Config

    FILE_NAME = "config.json"

    include FileUtils

    attr_reader :attributes

    #
    #
    #
    def initialize(workspace, project_name)
      @workspace = workspace
      @project_name = project_name
    end

    #
    # Current project folder
    #
    def folder
      puts @workspace.class
      @workspace.project_folder(@project_name)
    end

    #
    # Create a new configuration
    #
    def create
      bootstrap unless File.exist?(file)
      load_attributes
    end

    #
    # Create the default configuration
    #
    def bootstrap
      puts "No local configuration found, creating default configuration file into #{file}..."
      @attributes = {

          # The source information URL
          :source => {
              :url => 'http://gitorious.ow2.org',
              :type => 'gitorious',
              :username => '',
              :password => ''
          },

          :destination => {
              :url => 'http://github.com',
              :type => 'github',
              :username => '',
              :password => ''
          },

          # TODO
          :notifier => {
              :type => 'mail',
              :properties => {
                  :host => "stmp.gmail.com",
                  :port => "25",
                  :login => "chamerling.ebmws@gmail.com",
                  :password => "XXXX",
                  :to => "XXXX"
              }
          }
      }
      mkdir_p folder
      save
    end

    def attributes=(attrs)
      @attributes = attrs
      save
    end

    def file
      File.join(folder, FILE_NAME)
    end

    #
    # Load the configuration from the man configuration file
    #
    def load_attributes
      @attributes = MultiJson.decode(File.new(file, 'r').read)
    end

    #
    # Does the configuration file exists?
    #
    def exist?
      File.exist?(file)
    end

    #
    #
    #
    def save
      puts "Save to #{file}"
      File.open(file, 'w') { |f| f.write(json) }
    end

    #
    # Attributes as JSON
    #
    def json
      MultiJson.encode(attributes)
    end

    #
    # Define stdin accessor. Easier to mock...
    #
    def stdin
      $stdin
    end

    #
    # Configure from stdin
    #
    def configure

      load_attributes

      message = "Services configuration"
      puts message
      puts "-" * message.length
      puts

      @attributes['source']['url'] = ask("Define Source Service URL, current is '#{@attributes['source']['url']}'") do |q|
        q.default = @attributes['source']['url']
      end

      @attributes['source']['type'] = ask("Define Source Service type, current is '#{@attributes['source']['type']}' :") do |q|
        q.default = @attributes['source']['type']
      end

      @attributes['source']['username'] = ask("Define Source Service login, current is '#{@attributes['source']['username']}' :") do |q|
        q.default = @attributes['source']['username']
      end

      @attributes['source']['password'] = ask("Define Source Service password, current is '#{@attributes['source']['password']}' :") do |q|
        q.default = @attributes['source']['password']
        q.echo = '*'
      end

      @attributes['destination']['url'] = ask("Define Destination Service URL, current is '#{@attributes['destination']['url']}'") do |q|
        q.default = @attributes['destination']['url']
      end

      @attributes['destination']['type'] = ask("Define Destination Service type, current is '#{@attributes['destination']['type']}' :") do |q|
        q.default = @attributes['destination']['type']
      end

      @attributes['destination']['username'] = ask("Define Destination Service login, current is '#{@attributes['destination']['username']}' :") do |q|
        q.default = @attributes['destination']['username']
      end

      @attributes['destination']['password'] = ask("Define Destination Service password, current is '#{@attributes['destination']['password']}' :") do |q|
        q.default = @attributes['destination']['password']
        q.echo = '*'
      end

      # TODO : Get the notifier from its type and call configure on it

      puts ""
      message = "Summary"
      puts message
      puts "-" * message.length
      puts ""
      puts json

      save
    end
  end
end
