#
# Christophe Hamerling - OW2
#
# A workspace is a collection of projects.
# It provides easy ways to access to all the resources and to instanciate projects.
#
module Ow2mirror
  class Workspace

    include FileUtils

    # Contains all the workspace information such as the list of projects
    FILE_NAME = "workspace.json"

    # The workspace log folder
    LOGS_FOLDER = "logs"

    # The projects folder
    PROJECTS_FOLDER = "projects"

    REPORTS_FOLDER = "reports"

    attr_reader :attributes

    def initialize
      # Default workspace folder
      @pwd = pwd
    end

    #
    # Add a project to the workspace
    #
    def add_project(name)
      load_attributes

      # Add project name and date it has been added
      @attributes['projects'] << {:name => name, :date => "#{Time.now}"}
      save
    end

    #
    # Get a project instance if it exists in the current workspace
    #
    def project(name)
      Ow2mirror::Project.new(self, name)
    end

    #
    # Get the list of projects. Each project must have its dedicated subfolder .
    #
    def projects
      result = []
      load_attributes
      @attributes['projects'].each do |project|
        result << project['name']
      end
      puts "Workspace projects #{result}"
      result
    end

    #
    # Check if the project exists
    #
    def project_exists?(name)
      projects.include?(name)
    end

    #
    # Returns the project folder
    #
    def project_folder(name)
      File.join(projects_folder, name)
    end

    #
    # Returns the folder of the workspace
    #
    def workspace_folder
      @pwd
    end

    #
    # The projects folder
    #
    def projects_folder
      File.join(workspace_folder, PROJECTS_FOLDER)
    end

    #
    # The logs folder
    #
    def logs_folder
      File.join(workspace_folder, LOGS_FOLDER)
    end

    #
    # The reports folder
    #
    def reports_folder
      File.join(workspace_folder, REPORTS_FOLDER)
    end

    #
    # Create the workspace if it does not exists and laod it
    #
    def create
      bootstrap unless File.exist?(file)
      load_attributes
    end

    #
    # Creates initial structure
    #
    def bootstrap
      puts "Creating initial resources..."
      @attributes = {
          :projects => [],
          :created_at => "#{Time.now}",
          :version => "#{Ow2mirror::VERSION}"
      }

      puts "Creating work folders under #{workspace_folder}"
      mkdir_p projects_folder
      mkdir_p logs_folder
      mkdir_p reports_folder
      save
      puts "Done!"
    end

    #
    # Store a report to the reports folder
    #
    def save_report(project_name, hash)
      id = "report-#{project_name}-#{Time.now.strftime("%Y%m%d-%H:%M:%S")}.md"
      puts "Saving mirror report for project #{project_name} to #{id}"
      File.open(File.join(reports_folder, id), 'w') { |f| f.write(Ow2mirror::Report.generate_mirror(hash)) }
    end

    #
    #
    #
    def attributes=(attrs)
      @attributes = attrs
      save
    end

    #
    # Load the configuration from the man configuration file
    #
    def load_attributes
      @attributes = MultiJson.decode(File.new(file, 'r').read)
    end

    #
    # The projects file
    #
    def file
      "#{workspace_folder}/#{FILE_NAME}"
    end

    #
    #
    #
    def save
      puts "Save workspace information to #{file}"
      File.open(file, 'w') { |f| f.write(json) }
    end

    #
    #
    #
    def json
      MultiJson.encode(@attributes)
    end

    def display
      title = 'Workspace information'
      puts ""
      puts title
      puts "-" * title.length
      puts ""
      puts "Created at #{@attributes['created_at']} with version #{@attributes['version']}"
      puts "Folder : #{workspace_folder}"
      puts "Projects : "
      @attributes['projects'].each do |project|
        puts " - #{project['name']} (added on #{project['date']})"
      end

    end

  end
end