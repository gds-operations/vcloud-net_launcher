require 'spec_helper'
require 'pp'

describe Vcloud::Core::OrgVdcNetwork do

  context "natRouted network" do

    before(:all) do
      test_data = define_test_data
      @config = {
        :name => test_data[:name],
        :description => "Integration Test network #{@name}",
        :vdc_name => test_data[:vdc_name],
        :fence_mode => 'natRouted',
        :edge_gateway => test_data[:edge_gateway_name],
        :gateway => '10.88.11.1',
        :netmask => '255.255.255.0',
        :dns1 => '8.8.8.8',
        :dns2 => '8.8.4.4',
        :ip_ranges => [
            { :start_address => '10.88.11.100',
              :end_address   => '10.88.11.150' },
            { :start_address => '10.88.11.200',
              :end_address   => '10.88.11.250' },
          ],
      }
      @net = Vcloud::Core::OrgVdcNetwork.provision(@config)
    end

    it 'should be an OrgVdcNetwork' do
      expect(@net.class).to be(Vcloud::Core::OrgVdcNetwork)
    end

    it 'should have an id' do
      expect(@net.id).to match(/^[0-9a-f-]+$/)
    end

    it 'should have a name' do
      expect(@net.name).to eq(@config[:name])
    end

    it 'should have a :Gateway attribute' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:Gateway]).
        to eq(@config[:gateway])
    end

    it 'should have a :Netmask attribute' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:Netmask]).
        to eq(@config[:netmask])
    end

    it 'should have a :Dns1 attribute' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:Dns1]).
        to eq(@config[:dns1])
    end

    it 'should have a :Dns2 attribute' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:Dns2]).
        to eq(@config[:dns2])
    end

    it 'should have an :IpRange list with each of our ranges' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:IpRanges][:IpRange]).
        to match_array([
          { :StartAddress => '10.88.11.100', :EndAddress => '10.88.11.150' },
          { :StartAddress => '10.88.11.200', :EndAddress => '10.88.11.250' },
        ])
    end

    after(:all) do
      unless ENV['VCLOUD_TOOLS_RSPEC_NO_DELETE_ORG_VDC_NETWORK']
        Vcloud::Fog::ServiceInterface.new.delete_network(@net.id) if @net
      end
    end

  end

  context "isolated network" do

    before(:all) do
      test_data = define_test_data
      @config = {
        :name => test_data[:name],
        :description => "Integration Test network #{@name}",
        :vdc_name => test_data[:vdc_name],
        :fence_mode => 'isolated',
        :gateway => '10.88.11.1',
        :netmask => '255.255.255.0',
        :dns1 => '8.8.8.8',
        :dns2 => '8.8.4.4',
        :ip_ranges => [
            { :start_address => '10.88.11.100',
              :end_address   => '10.88.11.150' },
            { :start_address => '10.88.11.200',
              :end_address   => '10.88.11.250' },
          ],
      }
      @net = Vcloud::Core::OrgVdcNetwork.provision(@config)
    end

    it 'should be an OrgVdcNetwork' do
      expect(@net.class).to be(Vcloud::Core::OrgVdcNetwork)
    end

    it 'should have an id' do
      expect(@net.id).to match(/^[0-9a-f-]+$/)
    end

    it 'should have a name' do
      expect(@net.name).to eq(@config[:name])
    end

    it 'should have a :gateway attribute' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:Gateway]).
        to eq(@config[:gateway])
    end

    it 'should have a :netmask attribute' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:Netmask]).
        to eq(@config[:netmask])
    end

    it 'should have a :dns1 attribute' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:Dns1]).
        to eq(@config[:dns1])
    end

    it 'should have a :dns2 attribute' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:Dns2]).
        to eq(@config[:dns2])
    end

    it 'should have an :ip_ranges list with each of our ranges' do
      expect(@net.vcloud_attributes[:Configuration][:IpScopes][:IpScope][:IpRanges][:IpRange]).
        to match_array([
          { :StartAddress => '10.88.11.100', :EndAddress => '10.88.11.150' },
          { :StartAddress => '10.88.11.200', :EndAddress => '10.88.11.250' },
        ])
    end

    after(:all) do
      unless ENV['VCLOUD_TOOLS_RSPEC_NO_DELETE_ORG_VDC_NETWORK']
        Vcloud::Fog::ServiceInterface.new.delete_network(@net.id) if @net
      end
    end

  end

  def define_test_data
    config_file = File.join(File.dirname(__FILE__), "../vcloud_tools_testing_config.yaml")
    parameters = Vcloud::Tools::Tester::TestParameters.new(config_file)
    {
      :name => "orgVdcNetwork-vcloud-tools-tests #{Time.now.strftime('%s')}",
      :vdc_name => parameters.vdc_1_name,
      :edge_gateway_name => parameters.edge_gateway,
    }
  end

end

