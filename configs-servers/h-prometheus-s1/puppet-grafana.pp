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
  },
}
