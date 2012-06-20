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

      time = Time.now
      report = "# Mirroring report"
      report << "\n\n"
      report << "- Type : Mirror\n"
      report << "- Generated at : #{time}"
      report << "\n\n"
      report << "## Project logs"
      report << "\n"
      report << MultiJson.encode(hash)

    end

  end
end
