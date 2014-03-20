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

vCloud-tools uses Fog.

To use it you need a `.fog` file in your home directory.

For example:

    test:
      vcloud_director_username: 'username@org_name'
      vcloud_director_password: 'password'
      vcloud_director_host: 'host.api.example.com'

Unfortunately current usage of fog requires the password in this file. Multiple sets of credentials can be specified in the fog file, using the following format:

    test:
      vcloud_director_username: 'username@org_name'
      vcloud_director_password: 'password'
      vcloud_director_host: 'host.api.example.com'

    test2:
      vcloud_director_username: 'username@org_name'
      vcloud_director_password: 'password'
      vcloud_director_host: 'host.api.vendor.net'

You can then pass the `FOG_CREDENTIAL` environment variable at the start of your command. The value of the `FOG_CREDENTIAL` environment variable is the name of the credential set in your fog file which you wish to use.  For instance:

    FOG_CREDENTIAL=test2 vcloud-net-launch node.yaml

An example configuration file is located in [examples/vcloud-net-launch][example_yaml]


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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Other settings

vCloud Net Launcher uses vCloud Core. If you want to use the latest version of vCloud Core, or a local version, you can export some variables. See the Gemfile for details.

## Testing

Default target: `bundle exec rake` runs the integration tests.

You need access to a suitable vCloud Director organization to run the
integration tests. It is not necessarily safe to run them against an existing
environment, unless care is taken with the entities being tested.

The easiest thing to do is create a local shell script called
`vcloud_env.sh` and set the contents:

    export FOG\_CREDENTIAL=test
    export VCLOUD\_VDC\_NAME="Name of the VDC"
    export VCLOUD\_CATALOG\_NAME="catalog-name"
    export VCLOUD\_TEMPLATE\_NAME="name-of-template"
    export VCLOUD\_NETWORK1\_NAME="name-of-primary-network"
    export VCLOUD\_NETWORK2\_NAME="name-of-secondary-network"
    export VCLOUD\_NETWORK1\_IP="ip-on-primary-network"
    export VCLOUD\_NETWORK2\_IP="ip-on-secondary-network"
    export VCLOUD\_TEST\_STORAGE\_PROFILE="storage-profile-name"
    export VCLOUD\_EDGE\_GATEWAY="name-of-edge-gateway-in-vdc"

Then run this before you run the integration tests.

[example_yaml]: ../examples/vcloud-net-launch/

