require 'spec_helper'

describe Vcloud::NetLauncher::NetLaunch do
  context "ConfigLoader returns three different networks" do
    let(:network1) {
      {
        :name         => 'Network 1',
        :vdc_name     => 'TestVDC',
        :fence_mode   => 'isolated',
        :netmask      => '255.255.255.0',
        :gateway      => '10.0.1.1',
        :edge_gateway => 'TestVSE',
      }
    }
    let(:network2) {
      {
        :name         => 'Network 2',
        :vdc_name     => 'TestVDC',
        :fence_mode   => 'natRouted',
        :netmask      => '255.255.0.0',
        :gateway      => '10.0.2.1',
        :edge_gateway => 'TestVSE',
      }
    }
    let(:network3) {
      {
        :name         => 'Network 3',
        :vdc_name     => 'TestVDC',
        :fence_mode   => 'natRouted',
        :netmask      => '355.255.0.0',
        :gateway      => '10.0.3.1',
        :edge_gateway => 'TestVSE',
      }
    }

    before(:each) do
      config_loader = double(:config_loader)
      expect(Vcloud::Core::ConfigLoader).to receive(:new).and_return(config_loader)
      expect(config_loader).to receive(:load_config).and_return({
        :org_vdc_networks => [network1, network2, network3],
      })
    end

    it "should call provision once for each network" do
      expect(Vcloud::Core::OrgVdcNetwork).to receive(:provision).with(network1)
      expect(Vcloud::Core::OrgVdcNetwork).to receive(:provision).with(network2)
      expect(Vcloud::Core::OrgVdcNetwork).to receive(:provision).with(network3)

      cli_options = {}
      subject.run('input_config_yaml', cli_options)
    end

    it "should abort on errors from Vcloud::Core" do
      expect(Vcloud::Core::OrgVdcNetwork).to receive(:provision).with(network1)
      expect(Vcloud::Core::OrgVdcNetwork).to receive(:provision).with(network2).
        and_raise(RuntimeError.new('Did not successfully create orgVdcNetwork'))
      expect(Vcloud::Core::OrgVdcNetwork).not_to receive(:provision).with(network3)

      cli_options = {}
      expect {
        Vcloud::NetLauncher::NetLaunch.new.run('input_config_yaml', cli_options)
      }.to raise_error(RuntimeError, 'Did not successfully create orgVdcNetwork')
    end

    describe "fog mocking" do
      it "should not mock fog by default" do
        expect(Fog).to_not receive(:mock!)
        expect(Vcloud::Core::OrgVdcNetwork).to receive(:provision).exactly(3).times

        cli_options = {}
        subject.run('input_config_yaml', cli_options)
      end

      it "should mock fog when passed option" do
        expect(Fog).to receive(:mock!)
        expect(Vcloud::Core::OrgVdcNetwork).to receive(:provision).exactly(3).times

        cli_options = { :mock => true }
        subject.run('input_config_yaml', cli_options)
      end
    end

  end

  context "ConfigLoader returns one network without :fence_mode set" do
    let(:network_without_fence_mode) {
      {
        :name         => 'Network w/o fence_mode',
        :vdc_name     => 'TestVDC',
        :netmask      => '255.255.255.0',
        :gateway      => '10.0.1.1',
        :edge_gateway => 'TestVSE',
      }
    }

    before(:each) do
      config_loader = double(:config_loader)
      expect(Vcloud::Core::ConfigLoader).to receive(:new).and_return(config_loader)
      expect(config_loader).to receive(:load_config).and_return({
        :org_vdc_networks => [network_without_fence_mode],
      })
    end

    it "should default :fence_mode to isolated" do
      network_with_fence_mode = network_without_fence_mode.merge({
        :fence_mode => 'isolated',
      })

      expect(network_without_fence_mode).not_to have_key(:fence_mode)
      expect(Vcloud::Core::OrgVdcNetwork).to receive(:provision).with(network_with_fence_mode)

      cli_options = {}
      subject.run('input_config_yaml', cli_options)
    end
  end
end
