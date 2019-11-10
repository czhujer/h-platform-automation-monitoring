class { 'grafana':
  version => '5.3.4',
  cfg => {
    app_mode => 'production',
    server   => {
      http_port     => 8080,
    },
    users    => {
      allow_sign_up => false,
    },
  },
}
