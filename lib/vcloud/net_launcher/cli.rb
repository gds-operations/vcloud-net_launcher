require 'optparse'

module Vcloud
  module NetLauncher
    class Cli

      def initialize(argv_array)
        @usage_text = nil
        @config_file = nil
        @options = {
          "mock" => false,
        }

        parse(argv_array)
      end

      def run
        begin
          Vcloud::NetLauncher::NetLaunch.new.run(@config_file, @options)
        rescue => error_msg
          $stderr.puts(error_msg)
          exit 1
        end
      end

      private

      def parse(args)
        opt_parser = OptionParser.new do |opts|
          examples_dir = File.absolute_path(
            File.join(
              File.dirname(__FILE__),
              "..",
              "..",
              "..",
              "examples",
              File.basename($0),
            ))

          opts.banner = <<-EOS
Usage: #{$0} [options] config_file

vcloud-net-launch takes a configuration describing a vCloud network,
and tries to make it a reality.

See https://github.com/gds-operations/vcloud-tools for more info

Example configuration files can be found in:
  #{examples_dir}
          EOS

          opts.separator ""
          opts.separator "Options:"

          opts.on("-m", "--mock", "Fog Mock mode enabled") do
            @options["mock"] = true
          end

          opts.on("-h", "--help", "Print usage and exit") do
            $stderr.puts opts
            exit
          end

          opts.on("--version", "Display version and exit") do
            puts Vcloud::NetLauncher::VERSION
            exit
          end
        end

        @usage_text = opt_parser.to_s
        begin
          opt_parser.parse!(args)
        rescue OptionParser::InvalidOption => e
          exit_error_usage(e)
        end

        exit_error_usage("must supply config_file") unless args.size == 1
        @config_file = args.first
      end

      def exit_error_usage(error)
        $stderr.puts "#{$0}: #{error}"
        $stderr.puts @usage_text
        exit 2
      end
    end
  end
end
