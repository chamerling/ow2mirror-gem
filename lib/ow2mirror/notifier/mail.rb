#
# Christophe Hamerling - ow2.org
#

require 'pony'

module Ow2mirror
  module Notifier

    class Mail < Notify

      def bootstrap(properties)
        @server = properties[:host]
        @port = properties[:port]
        @login = properties[:login]
        @password = properties[:password]
        @to = properties[:to]
      end

      def configure

      end

      def notify (report)
        puts report

          Pony.mail :to => @to,
            :from => @login,
            :subject => 'Git Mirror report',
            :body =>  generate_report(report),
            :via => :smtp,
            :via_options => {
              :address => @server,
              :user_name => @login,
              :password => @password
            }
      end

      def generate_report(report)
        # TODO
        report
      end

    end
  end
end