require 'rubygems'
require 'bundler/setup'
require 'json'
require 'yaml'
require 'csv'
require 'open3'
require 'pp'

require 'vcloud/net_launcher/version'

require 'vcloud/fog'
require 'vcloud/core'

require 'vcloud/net_launcher/net_launch'

module Vcloud
  module NetLauncher

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

  end
end
