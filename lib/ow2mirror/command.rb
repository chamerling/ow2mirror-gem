#
# Christophe Hamerling - ow2.org
#
# System command wrapper
#
if RUBY_PLATFORM =~ /mswin|mingw/
  begin
    require 'win32/open3'
  rescue LoadError
    warn "You must 'gem install win32-open3' to use the git command on Windows"
    exit 1
  end
else
  require 'open3'
end

module Ow2mirror
  class Command
    class << self

      def git(command)
        run :sh, command
      end

      def sh(*command)
        Shell.new(*command).run
      end

      def run(method, command)
        command = 'git ' + command
        send method, *command
      end

      class Shell < String
        attr_reader :error
        attr_reader :out

        def initialize(*command)
          @command = command
        end

        def run
          puts ">>>>>>> Running sh command: '#{command}'"

          out = err = nil
          Open3.popen3(*@command) do |_, pout, perr|
            out = pout.read.strip
            err = perr.read.strip
          end

          replace @error = err unless err.empty?
          replace @out = out unless out.empty?

          self
        end

        def command
          @command.join(' ')
        end

        def error?
          !!@error
        end

        def out?
          !!@out
        end
      end

    end
  end

end
