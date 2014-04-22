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

### Credentials

vCloud Net Launcher is based around [fog]. To use it you'll need to give it credentials that allow it to talk to a VMware
environment. Fog offers two ways to do this.

#### 1. Create a `.fog` file containing your credentials

To use this method, you need a `.fog` file in your home directory.

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

    FOG_CREDENTIAL=test2 vcloud-net-launch networks.yaml

To understand more about `.fog` files, visit the 'Credentials' section here => http://fog.io/about/getting_started.html.

An example configuration file is located in [examples/vcloud-net-launch][example_yaml]

#### 2. Log on externally and supply your session token

You can choose to log on externally by interacting independently with the API and supplying your session token to the
tool by setting the `FOG_VCLOUD_TOKEN` ENV variable. This option reduces the risk footprint by allowing the user to
store their credentials in safe storage. The default token lifetime is '30 minutes idle' - any activity extends the life by another 30 mins.

A basic example of this would be the following:

    curl
       -D-
       -d ''
       -H 'Accept: application/*+xml;version=5.1' -u '<user>@<org>'
       https://host.com/api/sessions

This will prompt for your password.

From the headers returned, select the header below

     x-vcloud-authorization: AAAABBBBBCCCCCCDDDDDDEEEEEEFFFFF=

Use token as ENV var FOG_VCLOUD_TOKEN

    FOG_VCLOUD_TOKEN=AAAABBBBBCCCCCCDDDDDDEEEEEEFFFFF= vcloud-net-launch networks.yaml


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

## The vCloud API

vCloud Tools currently use version 5.1 of the [vCloud API](http://pubs.vmware.com/vcd-51/index.jsp?topic=%2Fcom.vmware.vcloud.api.doc_51%2FGUID-F4BF9D5D-EF66-4D36-A6EB-2086703F6E37.html). Version 5.5 may work but is not currently supported. You should be able to access the 5.1 API in a 5.5 environment, and this *is* currently supported.

The default version is defined in [Fog](https://github.com/fog/fog/blob/244a049918604eadbcebd3a8eaaf433424fe4617/lib/fog/vcloud_director/compute.rb#L32).

If you want to be sure you are pinning to 5.1, or use 5.5, you can set the API version to use in your fog file, e.g.

`vcloud_director_api_version: 5.1`

## Debugging

`export EXCON_DEBUG=true` - this will print out the API requests and responses.

`export DEBUG=true` - this will show you the stack trace when there is an exception instead of just the message.

## Testing

`bundle exec rake integration` runs the integration tests.

`bundle exec rake features` runs the cucumber features tests.

There are currently no unit tests here, though the bulk of the logic is
tested in vcloud-core.

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
[fog]: http://fog.io/

