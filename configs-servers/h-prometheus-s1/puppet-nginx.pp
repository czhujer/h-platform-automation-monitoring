#
#nginx part
#
class { 'nginx':
  package_source => 'nginx-stable',
  service_ensure => 'stopped',
  service_restart => false,
  service_enable => false,
  #service_manage => false,
  confd_purge   => true,
  #server_purge   => true,
  server_purge  => true,
  #
  manage_repo   => true,
  #
  log_format    => { 'timed_combined' => "\$remote_addr \$host \$remote_user [\$time_local]  '\n  '\"\$request\" \$status \$body_bytes_sent '\n  '\"\$http_referer\" \"\$http_user_agent\" \$request_time \$upstream_response_time \$pipe" },
  #
  client_max_body_size => "100M",
  # compression
  gzip_comp_level => 2,
  gzip_proxied  => "any",
  gzip_vary     => "on",
  gzip_types    => "text/plain text/xml text/css application/x-javascript application/javascript application/json",
  #
  server_tokens => 'off',
  #
  spdy          => 'off',
  http2         => 'on',
  nginx_cfg_prepend => {
    # load modules
    #'load_module' => '/usr/lib64/nginx/modules/ngx_http_server_traffic_status_module.so'},
    'load_module' => '/usr/lib/nginx/modules/ngx_http_opentracing_module.so',
  },
  http_cfg_append => {
    # enable vts module
    #'server_traffic_status_zone' => '',
    'opentracing_load_tracer' => '/usr/local/lib/libjaegertracing.so /etc/jaeger-nginx-config.json',
    'opentracing'             => 'on',
  },
  notify  => Docker::Run['nginx-opentracing'],
}

firewall { '120 accept tcp to dports 80,443 / NGINX':
    chain   => 'INPUT',
    state   => 'NEW',
    proto   => 'tcp',
    dport   => ['80', '443'],
    action  => 'accept',
}

firewall { '120 accept tcp to dports 80,443 / NGINX /v6':
    chain   => 'INPUT',
    state   => 'NEW',
    proto   => 'tcp',
    dport   => ['80', '443'],
    action  => 'accept',
    provider => 'ip6tables',
}

exec { "create custom dh params":
    command => "openssl dhparam -out /etc/pki/tls/dhparams.pem 2048",
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    unless => 'stat /etc/pki/tls/dhparams.pem',
    before => Service["nginx"],
}

nginx::resource::upstream { 'prometheus-http':
  members => {
    '172.17.0.1:9090' => {
      server => '172.17.0.1',
      port   => 9090,
    },
  },
}

nginx::resource::upstream { 'grafana-http':
  members => {
    '172.17.0.1:8080' => {
      server => '172.17.0.1',
      port   => 8080,
    },
  },
}

# nginx::resource::upstream { 'consul-http':
#   members => {
#     '127.0.0.1:8500' => {
#       server => '127.0.0.1',
#       port   => 8500,
#     },
#   },
# }

#default https server
#
nginx::resource::server { "${facts['ipaddress']}":
  listen_port  => 443,
  #
  proxy       => 'http://grafana-http',
  #
  ipv6_enable => true,
  ipv6_listen_options => '',
  #
  ssl         => true,
  ssl_dhparam => '/etc/pki/tls/dhparams.pem',
  ssl_cert    => '/etc/pki/tls/certs/localhost.crt',
  ssl_key     => '/etc/pki/tls/private/localhost.key',
  #ssl_ciphers => 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA',
  ssl_ciphers => 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA:!3DES:!DES-CBC3-SHA',
  ##
  #ssl_stapling        => true,
  #ssl_stapling_verify => true,
  #ssl_trusted_cert    => '/etc/pki/tls/certs/ca_rapidssl_stapling.pem',
  #
  add_header => {
      #because: better security
      #'Strict-Transport-Security' => '"max-age=31536000; includeSubDomains" always',
  },
  #
  #www_root    => "/var/www/html",
  location_cfg_append => {
      'proxy_set_header'   => [
                  # because: Inet <-> HTTPS (nginx) <-> HTTP (apache)
                  #'X-Forwarded-Proto $scheme',
                  # because: compression moved to nginx:
                  'Accept-Encoding ""',
      ],
      #because: better security
      #'add_header' => 'Strict-Transport-Security "max-age=31536000; includeSubDomains" always',
      'opentracing_operation_name' => '$uri',
      'opentracing_propagate_context' => '',
  },
}

nginx::resource::location { "${facts['ipaddress']}_status":
     ensure          => present,
     ssl             => true,
     ssl_only        => true,
     server          => "${facts['ipaddress']}",
     www_root        => "/var/www/html",
     location        => '/nginx_stat',
     proxy           => undef,
     stub_status      => true,
     location_allow   => ['127.0.0.1'],
     location_deny    => ['all'],
     location_cfg_append => {
         'access_log' => 'off',
     }
}

nginx::resource::location { 'http-prometheus':
  ensure          => present,
  www_root        => undef,
  ssl             => true,
  ssl_only        => true,
  server          => "${facts['ipaddress']}",
  location        => '/prometheus',
  proxy           => 'http://prometheus-http/prometheus',
  location_cfg_append => {
    'opentracing_operation_name' => '$uri',
    'opentracing_propagate_context' => '',
  },
}

# nginx::resource::location { 'http-consul-ui':
#   ensure          => present,
#   www_root        => undef,
#   ssl             => true,
#   ssl_only        => true,
#   server          => "${facts['ipaddress']}",
#   location        => '/ui/',
#   proxy           => 'http://consul-http/ui/',
# }
#
# nginx::resource::location { 'http-consul-v1':
#   ensure          => present,
#   www_root        => undef,
#   ssl             => true,
#   ssl_only        => true,
#   server          => "${facts['ipaddress']}",
#   location        => '/v1/',
#   proxy           => 'http://consul-http/v1/',
# }

# default http server
#
nginx::resource::server { 'h-prometheus-s1':
  #
  ipv6_enable => true,
  ipv6_listen_options => '',
  #
  ssl         => false,
  www_root    => "/var/www/html",
  location_cfg_append => {
    'rewrite' => "^ https://${facts['ipaddress']}? permanent",
    'opentracing_operation_name' => '$uri',
    'opentracing_propagate_context' => '',
  },
}

# selinux
selinux::boolean{ 'httpd_can_network_connect':
  ensure => 'on',
}

# tracing
# /etc/jaeger-nginx-config.json

$jaeger_nginx_config = '{
  "service_name": "nginx-monitoring",
  "sampler": {
    "type": "const",
    "param": 1
  },
  "reporter": {
    "localAgentHostPort": "172.17.0.1:6831"
  },
}
'

file { '/etc/jaeger-nginx-config.json':
  ensure  => 'file',
  mode    => '0644',
  content => $jaeger_nginx_config,
  before  => [Class['nginx'],
              Docker::Run['nginx-opentracing']],
  notify  => Docker::Run['nginx-opentracing'],
}
