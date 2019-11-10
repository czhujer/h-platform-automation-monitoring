
class { '::consul':
  config_hash => {
    'bootstrap_expect' => 1,
    'data_dir'         => '/opt/consul',
    'datacenter'       => 'h-dc1',
    'log_level'        => 'INFO',
    'node_name'        => 'h-consul-1',
    'server'           => true,
    'ui'               => true,
  },
  extra_options => "-advertise  ${facts['ipaddress']}",
}
