vCloud Net Launcher
===================

A tool that takes a YAML configuration file describing vCloud networks and configures each of them.

## Installation

Add this line to your application's Gemfile:

    gem 'vcloud-net_launcher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vcloud-net_launcher

## Usage

The form to run the command is
    vcloud-net-launch networks.yaml

## Credentials

Please see the [vcloud-tools usage documentation](http://gds-operations.github.io/vcloud-tools/usage/).

##Supports

* Configuration of multiple networks
* Supports natRouted and isolated network types
* Accepts multiple ip address ranges
* Defaults
  * IsShared : false
  * IpScope -> IsEnabled : true
  * IpScope -> IsInherited : false

Limitations

* Not currently reentrant - if the process errors part of the way through, the previously applied network config
will need to be removed from the file before it is corrected and run again.

* No support for deleting networks. If you need to reconfigure a network, delete it first using the vCloud Director
GUI and re-run `vcloud-net-launch`.

## Contributing

We welcome contributions. Please see the [contributing guidelines](/CONTRIBUTING.md).

## Other settings

vCloud Net Launcher uses vCloud Core. If you want to use the latest version of vCloud Core, or a local version, you can export some variables. See the Gemfile for details.

## The vCloud API

vCloud Tools currently use version 5.1 of the [vCloud API](http://pubs.vmware.com/vcd-51/index.jsp?topic=%2Fcom.vmware.vcloud.api.doc_51%2FGUID-F4BF9D5D-EF66-4D36-A6EB-2086703F6E37.html). Version 5.5 may work but is not currently supported. You should be able to access the 5.1 API in a 5.5 environment, and this *is* currently supported.

The default version is defined in [Fog](https://github.com/fog/fog/blob/244a049918604eadbcebd3a8eaaf433424fe4617/lib/fog/vcloud_director/compute.rb#L32).

If you want to be sure you are pinning to 5.1, or use 5.5, you can set the API version to use in your fog file, e.g.

`vcloud_director_api_version: 5.1`

## Debugging

`export EXCON_DEBUG=true` - this will print out the API requests and responses.

`export DEBUG=true` - this will show you the stack trace when there is an exception instead of just the message.

## Testing

Run the default suite of tests (e.g. lint, unit, features):

    bundle exec rake

Run the integration tests (slower and requires a real environment):

    bundle exec rake integration

You need access to a suitable vCloud Director organization to run the
integration tests. See the [integration tests README](/spec/integration/README.md) for further details.
