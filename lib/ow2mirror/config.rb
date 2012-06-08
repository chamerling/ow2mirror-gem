#
# Christophe Hamerling - ow2.org
#
module Ow2mirror
  class Config

    # Main configuration file
    FILE = "#{ENV['HOME']}/.gitmirror.conf"

    attr_reader :attributes

    def initialize
      bootstrap unless File.exist?(file)
      load_attributes
    end

    # Create the default configuration
    def bootstrap
      puts "Creating default configuration file into #{file}..."
      @attributes = {
          # Where to store things, relative to the user home
          :path => 'gitmirror',

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
              }
      }
      save

      puts 'Configuring mirror engine...'
      configure
    end

    def attributes=(attrs)
      @attributes = attrs
      save
    end

    def file
      FILE
    end

    #
    # Load the configuration from the man configuration file
    #
    def load_attributes
      @attributes = MultiJson.decode(File.new(file, 'r').read)
    end

    #
    #
    #
    def save
      json = MultiJson.encode(attributes)
      File.open(file, 'w') { |f| f.write(json) }
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

      puts ""
      message = "Local configuration"
      puts message
      puts "-" * message.length
      puts ""

      @attributes['path'] = ask("Define the mirror root folder (relative to your home #{ENV['HOME']}), current is '#{@attributes['path']}' :") do |q|
        q.default = @attributes['path']
      end

      # TODO : Display and validate before save

      save
    end
  end
end
