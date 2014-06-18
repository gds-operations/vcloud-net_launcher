require 'spec_helper'

describe Vcloud::NetLauncher do
  context "NetLaunch schema validation" do
    it "validates a legal schema" do
      test_config = {
        :org_vdc_networks => [
          :name     =>  "Valid network",
          :vdc_name =>  "Some vDC"
        ]
      }

      validator = Vcloud::Core::ConfigValidator.validate(:base, test_config, Vcloud::NetLauncher::Schema::NET_LAUNCH)
      expect(validator.valid?).to be_true
      expect(validator.errors).to be_empty
    end

    it "does not validate an illegal schema" do
      test_config = {
        :no_networks_here => {
          :name => "I am not valid"
        }
      }

      validator = Vcloud::Core::ConfigValidator.validate(:base, test_config, Vcloud::NetLauncher::Schema::NET_LAUNCH)
      expect(validator.valid?).to be_false
      expect(validator.errors).to eq(["base: parameter 'no_networks_here' is invalid", "base: missing 'org_vdc_networks' parameter"])
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
      expect(validator.valid?).to be_true
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
      expect(validator.valid?).to be_false
      expect(validator.errors).to eq(["ip_ranges: missing 'end_address' parameter"])
    end
  end
end
