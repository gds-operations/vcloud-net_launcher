# SimpleCov must run _first_ according to its README
if ENV['COVERAGE']
  require 'simplecov'

  # monkey-patch to prevent SimpleCov from reporting coverage percentage
  class SimpleCov::Formatter::HTMLFormatter
    def output_message(_message)
      nil
    end
  end

  SimpleCov.adapters.define 'gem' do
    add_filter '/spec/'
    add_filter '/features/'
    add_filter '/vendor/'

    add_group 'Libraries', '/lib/'
  end

  SimpleCov.minimum_coverage(100)
  SimpleCov.start 'gem'
end

require 'erb_helper'
require 'bundler/setup'
require 'vcloud/net_launcher'
require 'vcloud/tools/tester'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
