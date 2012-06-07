#
# Christophe Hamerling - ow2.org
#
module Ow2mirror
  class Cli

    class << self

      #
      # Main entry point
      #
      def execute(*args)

        # Gitmirror.foo

        command = args.shift
        major = args.shift
        minor = args.empty? ? nil : args.join(' ')

        return overview unless command
        delegate(command, major, minor)
      end

      #
      # Redefine puts for mocking
      #
      def output(s)
        puts(s)
      end

      def overview
        output "Invalid command, type 'gitmirror help' to get help..."
      end

      def delegate(command, major, minor)

        check_configuration

        return configure if command == 'configure'
        return mirror if command == 'mirror'
        return create if command == 'create'

        # Other not interesting stuff...
        return version if command == "-v" || command == "version"
        return help if command == 'help'

        # Test methods
        return test if command == 'test'

        return help
      end

      # Check that we have a configuration file with required params
      def check_configuration


      end

      def configure
        Ow2mirror.config.configure
      end

      #
      # Create a new mirror for the given input project
      #
      def create
        config = Ow2mirror.config

        properties = {
            :name => "",
            :prefix => "",
            :repositories => "*"
        }

        client = Ow2mirror::Client::GitoriousClient.new({:url => config.attributes['source']['url']})
        projects = client.projects

        choose do |menu|
          menu.prompt = "Which source project to mirror?"
          menu.choices(*projects) do |choice|
            properties[:name] = choice
            say "Selected project is #{choice}"
          end
        end

        repos = client.repositories(properties[:name])
        repo_names = []
        repos.each do |input|
          repo_names << input[:name]
        end

        # TODO: Multiple choices with highline
        puts "Which source repositories do you want to mirror (possible value are : * for all and CSV value to choose some)"
        begin
          puts "Source values are:"
          puts " - #{CSV.generate_line(repo_names)}"
          repositories = stdin.gets.chomp
        end while repositories.length == 0
        properties[:repositories] = repositories

        properties[:target] = ask("Target project?")

        properties[:prefix] = ask("Prefix of the target repositories ('cause we host many in the same target project/org...)")

        puts properties

        create_mirror(config, properties)
      end

      def create_mirror(config, properties)
        project = Ow2mirror::Project.new(config, properties)
        project.create_mirror
      end

      def version
        output "Running ow2mirror v#{Ow2mirror::VERSION}"
      end

      def help
        output "NOP..."
      end

      def test

      end

      def stdin
        $stdin
      end

    end

  end
end
