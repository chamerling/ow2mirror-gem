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
        output "Invalid command, type 'ow2mirror help' to get help..."
      end

      def delegate(command, major, minor)

        return install if command == 'install'
        return mirror if command == 'mirror'
        return create if command == 'create'

        # Other not interesting stuff...
        return version if command == "-v" || command == "version"
        return help if command == 'help'

        # Test methods
        return test if command == 'test'

        # default
        return help
      end

      #
      # Create all the required stuff for the Mirror
      #
      def install
        puts "Creating the default configuration files..."
        ws = Ow2mirror.workspace
        puts ws.create
        puts "Workspace created under #{ws.workspace_folder}"
        puts ws.display
      end

      #
      # Create a new mirror (project) for the given input project
      #
      def create

        # TODO : check if the workspace has been created before...

        output "Creating a new project mirror..."
        project_name = ask("Project Name ?")

        config = Ow2mirror::Config.new(Ow2mirror.workspace, project_name)
        config.create
        config.configure

        client = Ow2mirror::Client::GitoriousClient.new({:url => config.attributes['source']['url']})
        puts "Getting available projects from #{config.attributes['source']['url']}, please wait..."
        projects = client.projects

        project_source = nil
        choose do |menu|
          menu.prompt = "Which source project to mirror?"
          menu.choices(*projects) do |choice|
            project_source = choice
            say "Selected project is #{choice}"
          end
        end

        fail("Project source can not be null!") if project_source.nil?

        puts "Getting repositories from source system, please wait..."
        repos = client.repositories(project_source)
        repo_names = []
        repos.each do |input|
          repo_names << input[:name]
        end

        # TODO: Multiple choices with highline
        puts "Which source repositories do you want to mirror (possible value are : * for all and CSV value to choose some)"
        begin
          puts "Source values are:"
          puts " - #{CSV.generate_line(repo_names)}"
          project_repos = stdin.gets.chomp
        end while project_repos.length == 0

        project_target = ask("Target project (organisation for github)?")
        project_prefix = ask("Prefix of the target repositories ('cause we host many in the same target project/org...)")

        create_mirror(config, project_name, project_prefix, project_repos, project_source, project_target)
        output "Done!"

      end

      #
      # Create mirror based on configuration and properties. Can be used directly or through the create method.
      #
      def create_mirror(config, project_name, project_prefix, project_repos, project_source, project_target)
        config.save
        project = Ow2mirror.workspace.project(project_name)
        project.create(project_source, project_target, project_prefix, project_repos)
        project.create_mirror
      end

      #
      # Mirror repositories from the local folder. This is used when mirror has already been created with the create_mirror
      # method. This is typically called by a cron job.
      #
      def mirror
        puts "Mirroring projects..."

        # TODO Can not mirror if no workspace nor projects already configured...

        ws = Ow2mirror.workspace
        ws.projects.each do |p|
          puts "Mirroring project #{p}..."

          start = Time.now
          project = ws.project(p)
          project.mirror
          Ow2mirror.workspace.save_report(p,
              {:project => p, :type => "mirror", :start_time => "#{start}", :end_time => "#{Time.now}", :status => "OK"})
        end

      end

      def version
        output "Running ow2mirror v#{Ow2mirror::VERSION}"
      end

      def help
        output "NOP..."
      end

      def stdin
        $stdin
      end

      #
      #
      #
      def test
        puts "TEST METHOD"
      end

    end
  end
end
