require 'fog'

module Vcloud
  module NetLauncher
    class NetLaunch

      # Initializes instance variables.
      #
      # @return [void]
      def initialize
        @config_loader = Vcloud::Core::ConfigLoader.new
      end

      # Parses a configuration file and provisions the networks it defines.
      #
      # @param  config_file [String]  Path to a YAML or JSON-formatted configuration file
      # @return [void]
      def run(config_file = nil)
        config = @config_loader.load_config(config_file, Vcloud::NetLauncher::Schema::NET_LAUNCH)

        config[:org_vdc_networks].each do |net_config|
          net_config[:fence_mode] ||= 'isolated'
          Vcloud::Core.logger.info("Provisioning orgVdcNetwork #{net_config[:name]}.")
          begin
            Vcloud::Core::OrgVdcNetwork.provision(net_config)
          rescue RuntimeError => e
            Vcloud::Core.logger.error("Could not provision orgVdcNetwork: #{e.message}")
            raise
          end
        end
      end
    end
  end
end
