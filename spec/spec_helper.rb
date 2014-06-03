require 'erb_helper'
require 'bundler/setup'
require 'vcloud/net_launcher'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
