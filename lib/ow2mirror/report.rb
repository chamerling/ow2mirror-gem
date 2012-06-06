#
# Reporting mirror creation
#
module Ow2mirror
  class Report

    attr_accessor :attributes

    def initialize(config, project)
      @config = config
      @project = project
    end

    def attributes=(attrs)
      @attributes = attrs
      save
    end

    def file
      "#{ENV['HOME']}#{config.attributes[:path]}/#{project}/report.json"
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
      File.open(file, 'w') {|f| f.write(json) }
      end
  end
end
