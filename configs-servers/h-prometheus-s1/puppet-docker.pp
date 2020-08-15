#
# https://forge.puppet.com/puppetlabs/docker
#

class { 'docker':
  use_upstream_package_source => false,
  service_overrides_template  => false,
  docker_ce_package_name      => 'docker',
  docker_group                => 'dockerroot',
}

docker::run { 'jaeger-agent':
  image   => 'jaegertracing/jaeger-agent:1.18',
  command => "--reporter.grpc.host-port=192.168.121.254:14250",
  ports   => ['6831:6831/udp', '6832:6832/udp'],
}
