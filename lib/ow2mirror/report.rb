#
# Christophe Hamerling - OW2
#
# Reporting mirror creation
#
module Ow2mirror
  class Report

    #
    # Generate a mirroring report from hash
    #
    def Report.generate_mirror(hash)

      json = MultiJson.encode(hash)
      time = Time.now
      id = "report-#{time.strftime("%Y%m%d-%H:%M:%S")}.md"

      report = "# Mirroring report (generated at #{time})"
      report << "\n"
      report << "## Projects logs"
      report << "\n"
      report << json

    end

  end
end
