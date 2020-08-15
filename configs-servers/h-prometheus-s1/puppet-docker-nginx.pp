docker::run { 'nginx-opentracing':
  image   => 'opentracing/nginx-opentracing:0.9.0',
  ports   => ['80:80','443:443'],
  volumes => ['/etc/nginx:/etc/nginx',
              '/etc/pki/tls/certs:/etc/pki/tls/certs',
              '/etc/pki/tls/private:/etc/pki/tls/private',
              '/etc/pki/tls/dhparams.pem:/etc/pki/tls/dhparams.pem',
              '/var/nginx/client_body_temp:/var/nginx/client_body_temp',
              '/etc/jaeger-nginx-config.json:/etc/jaeger-nginx-config.json',
  ],
}
