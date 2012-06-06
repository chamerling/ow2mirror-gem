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

      puts "> Source Service URL, current is '#{@attributes['source']['url']}' :"
      input = stdin.gets.chomp
      if !input.empty?
        @attributes['source']['url'] = input
      end
      puts "< '#{@attributes['source']['url']}'"

      puts "> Source Service type, current is '#{@attributes['source']['type']}' :"
      input = stdin.gets.chomp
      if !input.empty?
        @attributes['source']['type'] = input
      end
      puts "< '#{@attributes['source']['type']}'"

      puts "> Source Service login, current is '#{@attributes['source']['username']}' :"
      input = stdin.gets.chomp
      if !input.empty?
        @attributes['source']['username'] = input
      end
      puts "< '#{@attributes['source']['username']}'"

      puts "> Source Service password, current is '#{@attributes['source']['password']}' :"
      input = stdin.gets.chomp
      if !input.empty?
        @attributes['source']['password'] = input
      end
      puts "< '#{@attributes['source']['password']}'"

      puts "> Target Service URL, current is '#{@attributes['destination']['url']}' :"
      input = stdin.gets.chomp
      if !input.empty?
        @attributes['destination']['url'] = input
      end
      puts "< '#{@attributes['destination']['url']}'"

      puts "Target Service type, current is '#{@attributes['destination']['type']}' :"
      input = stdin.gets.chomp
      if !input.empty?
        @attributes['destination']['type'] = input
      end
      puts "< '#{@attributes['destination']['type']}'"

      puts "> Target Service login, current is '#{@attributes['destination']['username']}' :"
      input = stdin.gets.chomp
      if !input.empty?
        @attributes['destination']['username'] = input
      end
      puts "< '#{@attributes['destination']['username']}'"

      puts "Target Service password, current is '#{@attributes['destination']['password']}' :"
      input = stdin.gets.chomp
      if !input.empty?
        @attributes['destination']['password'] = input
      end
      puts "< '#{@attributes['destination']['password']}'"

      puts ""
      message = "Local configuration"
      puts message
      puts "-" * message.length
      puts ""

      puts "Define the mirror root folder (relative to your home #{ENV['HOME']}), current is '#{@attributes['path']}' :"
      input = stdin.gets.chomp
      if !input.empty?
        @attributes['path'] = input
      end
      puts "< '#{@attributes['path']}'"

      save
    end
  end
end
