require 'spec_helper'

class CommandRun
  attr_accessor :stdout, :stderr, :exitstatus

  def initialize(args)
    out = StringIO.new
    err = StringIO.new

    $stdout = out
    $stderr = err

    begin
      Vcloud::NetLauncher::Cli.new(args).run
      @exitstatus = 0
    rescue SystemExit => e
      # Capture exit(n) value.
      @exitstatus = e.status
    end

    @stdout = out.string.strip
    @stderr = err.string.strip

    $stdout = STDOUT
    $stderr = STDERR
  end
end

describe Vcloud::NetLauncher::Cli do
  subject { CommandRun.new(args) }

  let(:mock_net_launch) {
    double(:net_launch, :run => true)
  }
  let(:net_config_file) { 'config.yaml' }

  describe "under normal usage" do
    shared_examples "a good CLI command" do
      it "passes the right CLI options and exits normally" do
        expect(Vcloud::NetLauncher::NetLaunch).to receive(:new).
          and_return(mock_net_launch)
        expect(mock_net_launch).to receive(:run).
          with(net_config_file, cli_options)
        expect(subject.exitstatus).to eq(0)
      end
    end

    context "when given a single config file" do
      let(:args) { [ net_config_file ] }
      let(:cli_options) {
        {
          "mock" => false,
        }
      }

      it_behaves_like "a good CLI command"
    end

    context "when asked to use mock mode" do
      let(:args) { [ net_config_file, "--mock" ] }
      let(:cli_options) {
        {
          "mock" => true,
        }
      }

      it_behaves_like "a good CLI command"
    end

    context "when asked to display version" do
      let(:args) { %w{--version} }

      it "does not call NetLaunch" do
        expect(Vcloud::NetLauncher::NetLaunch).not_to receive(:new)
      end

      it "prints version and exits normally" do
        expect(subject.stdout).to eq(Vcloud::NetLauncher::VERSION)
        expect(subject.exitstatus).to eq(0)
      end
    end

    context "when asked to display help" do
      let(:args) { %w{--help} }

      it "does not call NetLaunch" do
        expect(Vcloud::NetLauncher::NetLaunch).not_to receive(:new)
      end

      it "prints usage and exits normally" do
        expect(subject.stderr).to match(/\AUsage: \S+ \[options\] net_config_file\n/)
        expect(subject.exitstatus).to eq(0)
      end
    end
  end

  describe "incorrect usage" do
    shared_examples "print usage and exit abnormally" do |error|
      it "does not call NetLaunch" do
        expect(Vcloud::NetLauncher::NetLaunch).not_to receive(:new)
      end

      it "prints error message and usage" do
        expect(subject.stderr).to match(/\A\S+: #{error}\nUsage: \S+/)
      end

      it "exits abnormally for incorrect usage" do
        expect(subject.exitstatus).to eq(2)
      end
    end

    context "when run without any arguments" do
      let(:args) { %w{} }

      it_behaves_like "print usage and exit abnormally", "must supply net_config_file"
    end

    context "when given multiple config files" do
      let(:args) { %w{one.yaml two.yaml} }

      it_behaves_like "print usage and exit abnormally", "must supply net_config_file"
    end

    context "when given an unrecognised argument" do
      let(:args) { %w{--this-is-garbage} }

      it_behaves_like "print usage and exit abnormally", "invalid option: --this-is-garbage"
    end
  end

  describe "error handling" do
    context "when underlying code raises an exception" do
      let(:args) { %w{test.yaml} }

      it "should print error without backtrace and exit abnormally" do
        expect(Vcloud::NetLauncher::NetLaunch).to receive(:new).
          and_raise("something went horribly wrong")
        expect(subject.stderr).to eq("something went horribly wrong")
        expect(subject.exitstatus).to eq(1)
      end
    end

    context "when passed an non-existent configuration file" do
      let(:args) { %w{non-existent.yaml} }

      it "raises a descriptive error" do
        expect(subject.stderr).to eq("No such file or directory - non-existent.yaml")
        expect(subject.exitstatus).to eq(1)
      end
    end
  end
end
