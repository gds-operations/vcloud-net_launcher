module Vcloud
  module NetLauncher
    module Schema

      NET_LAUNCH = {
        type: 'hash',
        internals: {
          org_vdc_networks: {
            type: 'array',
            required: true,
            each_element_is: {
              type: 'hash',
              internals: {
                name: {
                  type: 'string',
                  required: true,
                },
                description: {
                  type: 'string',
                  required: false,
                },
                edge_gateway: {
                  type: 'string',
                  required: false,
                },
                vdc_name: {
                  type: 'string',
                  required: true,
                },
                fence_mode: {
                  type: 'enum',
                  required: false,
                  acceptable_values: %w{ isolated natRouted },
                },
                is_shared: {
                  type: 'boolean',
                  required: false,
                },
                is_inherited: {
                  type: 'boolean',
                  required: false,
                },
                is_enabled: {
                  type: 'boolean',
                  required: false,
                },
                gateway: {
                  type: 'ip_address',
                  required: false,
                },
                netmask: {
                  type: 'ip_address',
                  required: false,
                },
                dns_suffix: {
                  type: 'string',
                  required: false,
                },
                dns1: {
                  type: 'ip_address',
                  required: false,
                },
                dns2: {
                  type: 'ip_address',
                  required: false,
                },
                ip_ranges: {
                  type: 'array',
                  required: false,
                  each_element_is: {
                    type: 'hash',
                    required: true,
                    internals: {
                      start_address: {
                        type: 'ip_address',
                        required: true,
                      },
                      end_address: {
                        type: 'ip_address',
                        required: true,
                      },
                    },
                  },
                },
              },
            },
          },
        },
      }

    end
  end
end
