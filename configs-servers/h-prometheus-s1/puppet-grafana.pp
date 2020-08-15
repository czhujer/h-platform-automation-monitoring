class { 'grafana':
  version => '7.1.3',
  cfg => {
    app_mode => 'production',
    server   => {
      http_port     => 8080,
    },
    users    => {
      allow_sign_up => false,
    },
    # https://grafana.com/docs/grafana/latest/administration/configuration/#tracingjaeger
    "tracing.jaeger" => {
        address => "172.17.0.1:6831",
    },
    log  => {
      level => "info",
    }
  },
}
