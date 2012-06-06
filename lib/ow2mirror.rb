#
# Christophe Hamerling - ow2.org
#
begin
  require 'rubygems'
rescue LoadError
end

require 'fileutils'
require 'multi_json'
require 'httparty'
require 'open-uri'
require 'xml'

# Setting the LOADPATH
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "ow2mirror/cli"
require "ow2mirror/config"
require "ow2mirror/config"
require "ow2mirror/command"
require "ow2mirror/project"
require "ow2mirror/client/client"
require "ow2mirror/client/gitorious_client"
require "ow2mirror/client/github_client"

module Ow2mirror
  VERSION = '0.0.1'

  extend self

  def config
    @config ||= Ow2mirror::Config.new
  end

end
