require 'spec_helper'
require 'pp'
require 'erb'

module Vcloud
  module NetLauncher
    describe NetLaunch do

      context 'with minimum input setup' do

        it 'should create an isolated network' do
          test_data = default_test_data('isolated')
          @minimum_data_yaml = generate_data_file(test_data)

          Vcloud::NetLauncher::NetLaunch.new.run(@minimum_data_yaml)

          @found_networks = find_network(test_data[:network_name])
          expect(@found_networks.length).to eq(1)
          provisioned_network = @found_networks[0]
          expect(provisioned_network[:gateway]).to eq(test_data[:gateway])
          expect(provisioned_network[:netmask]).to eq(test_data[:netmask])
          expect(provisioned_network[:isLinked]).to eq('false')
        end

        it 'should create a nat routed network' do
          test_data = default_test_data('natRouted')
          @minimum_data_yaml = generate_data_file(test_data)

          Vcloud::NetLauncher::NetLaunch.new.run(@minimum_data_yaml)

          @found_networks = find_network(test_data[:network_name])

          expect(@found_networks.length).to eq(1)
          provisioned_network = @found_networks[0]
          expect(provisioned_network[:gateway]).to eq(test_data[:gateway])
          expect(provisioned_network[:netmask]).to eq(test_data[:netmask])
          expect(provisioned_network[:isLinked]).to eq('true')
        end

        after(:each) do
          unless ENV['VCLOUD_TOOLS_RSPEC_NO_DELETE_VAPP']
            File.delete @minimum_data_yaml
            fog_interface = Vcloud::Fog::ServiceInterface.new
            provisioned_network_id = @found_networks[0][:href].split('/').last
            expect(fog_interface.delete_network(provisioned_network_id)).to be(true)
          end
        end

      end

      def default_test_data(type)
        config_file = File.join(File.dirname(__FILE__), "../vcloud_tools_testing_config.yaml")
        parameters = Vcloud::Tools::Tester::TestSetup.new(config_file, []).test_params
        {
          network_name: "vapp-vcloud-tools-tests-#{Time.now.strftime('%s')}",
          vdc_name: parameters.vdc_1_name,
          edge_gateway: parameters.edge_gateway,
          fence_mode: type,
          netmask: '255.255.255.0',
          gateway: '192.0.2.1',
        }
      end

      def find_network(network_name)
        query = Vcloud::Core::QueryRunner.new()
        query.run('orgNetwork', :filter => "name==#{network_name}")
      end

      def generate_data_file(test_data)
        minimum_data_erb = File.join(File.dirname(__FILE__), 'data/minimum_data_setup.yaml.erb')
        ErbHelper.convert_erb_template_to_yaml(test_data, minimum_data_erb)
      end
    end
  end
end
