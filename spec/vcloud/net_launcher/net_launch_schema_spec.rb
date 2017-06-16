require 'spec_helper'

describe Vcloud::NetLauncher do
  context "NetLaunch schema validation" do
    it "validates a legal minimal schema" do
      test_config = {
        :org_vdc_networks => [
          :name     =>  "Valid network",
          :vdc_name =>  "Some vDC"
        ]
      }

      validator = Vcloud::Core::ConfigValidator.validate(:base, test_config, Vcloud::NetLauncher::Schema::NET_LAUNCH)
      expect(validator.valid?).to be true
      expect(validator.errors).to be_empty
    end

    it "validates a legal more complete schema" do
      test_config = {
        :org_vdc_networks => [ {
          :name        =>  "Valid network",
          :description => "A description of this network",
          :vdc_name    =>  "Some vDC",
          :fence_mode  =>  "isolated",
          :is_shared   =>  true,
          :gateway     =>  "192.0.2.1",
          :netmask     =>  "255.255.255.0",
          :dns_suffix  =>  "mynet.example.com",
          :dns1        =>  "192.0.2.11",
          :dns2        =>  "192.0.2.12",
        }]
      }

      validator = Vcloud::Core::ConfigValidator.validate(:base, test_config, Vcloud::NetLauncher::Schema::NET_LAUNCH)
      expect(validator.valid?).to be true
      expect(validator.errors).to be_empty
    end

    it "does not validate an illegal schema" do
      test_config = {
        :no_networks_here => {
          :name => "I am not valid"
        }
      }

      validator = Vcloud::Core::ConfigValidator.validate(:base, test_config, Vcloud::NetLauncher::Schema::NET_LAUNCH)
      expect(validator.valid?).to be false
      expect(validator.errors).to eq(["base: parameter 'no_networks_here' is invalid", "base: missing 'org_vdc_networks' parameter"])
    end

    it "allows anchors" do
      test_config = {
        :anchors => {
          foo: :bar,
        },
        :org_vdc_networks => [
          :name       =>  "Valid network",
          :vdc_name   =>  "Some vDC",
        ]
      }
      validator = Vcloud::Core::ConfigValidator.validate(:base, test_config, Vcloud::NetLauncher::Schema::NET_LAUNCH)
      expect(validator.valid?).to be true
      expect(validator.errors).to be_empty
    end

    it "allows multiple IP ranges" do
      test_config = {
        :org_vdc_networks => [
          :name       =>  "Valid network",
          :vdc_name   =>  "Some vDC",
          :ip_ranges  =>  [
            {
              :start_address  =>  "192.168.1.2",
              :end_address    =>  "192.168.1.3",
            },
            {
              :start_address  =>  "192.168.1.4",
              :end_address    =>  "192.168.1.5",
            }
          ]
        ]
      }

      validator = Vcloud::Core::ConfigValidator.validate(:base, test_config, Vcloud::NetLauncher::Schema::NET_LAUNCH)
      expect(validator.valid?).to be true
      expect(validator.errors).to be_empty
    end

    it "checks for an end address in an IP address range" do
      test_config = {
        :org_vdc_networks => [
          :name       =>  "Valid network",
          :vdc_name   =>  "Some vDC",
          :ip_ranges  =>  [
            {
              :start_address  => "192.168.1.2",
            }
          ]
        ]
      }

      validator = Vcloud::Core::ConfigValidator.validate(:base, test_config, Vcloud::NetLauncher::Schema::NET_LAUNCH)
      expect(validator.valid?).to be false
      expect(validator.errors).to eq(["ip_ranges: missing 'end_address' parameter"])
    end
  end
end
