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
#require 'xml'
require 'highline/import'

# Setting the LOADPATH
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "ow2mirror/cli"
require "ow2mirror/config"
require "ow2mirror/config"
require "ow2mirror/command"
require "ow2mirror/project"
require "ow2mirror/workspace"
require "ow2mirror/client/client"
require "ow2mirror/client/gitorious_client"
require "ow2mirror/client/github_client"

module Ow2mirror
  VERSION = '0.0.1'

  extend self

  def workspace
    @workspace ||= Ow2mirror::Workspace.new
  end

end
