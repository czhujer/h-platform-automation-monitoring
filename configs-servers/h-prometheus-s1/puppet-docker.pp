#
# https://forge.puppet.com/puppetlabs/docker
#

class { 'docker':
  use_upstream_package_source => false,
  service_overrides_template  => false,
  docker_ce_package_name      => 'docker',
  docker_group                => 'dockerroot',
}
