class { 'prometheus::server':
    version        => '2.13.1',
    external_url   => "https://${facts['ipaddress']}/prometheus/",
    #extra_options  => "--web.route-prefix=/",
    storage_retention => '30d',
    alertmanagers_config => [{ 'static_configs' => [{'targets' => [ 'localhost:9093' ]}]}],

    alerts => { 
             'groups' => [
                {
                  'name' => 'alert.rules',
                  'rules' => [{
                     'alert' => 'InstanceDown', 
                     'expr' => 'up == 0',
                     'for' => '5m',
                     'labels' => { 'severity' => 'page', },
                     'annotations' => { 
                          'summary' => 'Instance {{ $labels.instance }} down',
                          'description' => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
                    }
                 }]}]
              },


    scrape_configs => [
      { 'job_name' => 'prometheus',
        'scrape_interval' => '1m',
        'scrape_timeout'  => '10s',
        'metrics_path'    => '/prometheus/metrics',
        'static_configs'  => [
        { 'targets' => [ 'localhost:9090' ],
          'labels'  => { 'alias' => 'h-prometheus-s1'}
       }
      ]
    },
    { 'job_name' => 'node',
      'scrape_interval' => '1m',
      'static_configs' => [
      { 'targets' => [
                      'h-prometheus-s1:9100',
                     ]
      }
      ]
    },
    { 'job_name' => 'blackbox-localhost',
      'scrape_interval' => '1m',
      'scrape_timeout' => '10s',
      'metrics_path' => '/probe',
      'params'       => { 'module' => [http_2xx] },
      'static_configs' => [
      { 'targets' => [
                     # Inet
                     'https://github.com',
                     'https://uptimerobot.com',
                     ]
      }
      ],
      'relabel_configs' => [
      { 'source_labels' => '[__address__]',
        'target_label' => '__param_target',
      },
      { 'source_labels' => '[__param_target]',
        'target_label' => 'instance',
      },
      { 'target_label' => '__address__',
        'replacement' => '127.0.0.1:9115',
      }
      ]
    },
    { 'job_name' => 'snmp-localhost',
      'metrics_path' => '/snmp',
      'params'       => { 'module' => [if_mib] },
      'static_configs' => [
      { 'targets' => [
                     ]
      }
      ],
      'relabel_configs' => [
      { 'source_labels' => '[__address__]',
        'target_label' => '__param_target',
      },
      { 'source_labels' => '[__param_target]',
        'target_label' => 'instance',
      },
      { 'target_label' => '__address__',
        'replacement' => '127.0.0.1:9116',
      }
      ]
    },
    { 'job_name' => 'file-sd-node-ocb2b',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-node/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/ocb2b/node-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
    { 'job_name' => 'file-sd-mysql-ocb2b',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-mysql/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/ocb2b/mysql-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
    { 'job_name' => 'file-sd-apache-ocb2b',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-apache/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/ocb2b/apache-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
    { 'job_name' => 'file-sd-redis-ocb2b',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-redis/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/ocb2b/redis-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
    { 'job_name' => 'file-sd-node-dcops-https',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-node/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/dcops-https/node-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
    { 'job_name' => 'file-sd-node-ocb2c',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-node/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/ocb2c/node-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
    { 'job_name' => 'file-sd-mysql-ocb2c',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-mysql/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/ocb2c/mysql-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
    { 'job_name' => 'file-sd-apache-ocb2c',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-apache/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/ocb2c/apache-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
    { 'job_name' => 'file-sd-redis-ocb2c',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-redis/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/ocb2c/redis-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
    { 'job_name' => 'file-sd-php-fpm-ocb2c',
      'scrape_interval' => '1m',
      'scrape_timeout'  => '10s',
      'metrics_path'    => '/exporter-php-fpm/metrics',
      'scheme'          => 'https',
      'file_sd_configs' => [
        'files' => ['/etc/prometheus_sd_file/ocb2c/php-fpm-*.yml'],
        'refresh_interval' => '10m',
      ],
    },
  ]
}

class { 'prometheus::alertmanager':
  version => '0.19.0',
  route     => {
                 'group_by' => [ 'alertname', 'cluster', 'service' ],
                 'group_wait'=> '30s',
                 'group_interval'=> '5m',
                 'repeat_interval'=> '3h',
                 'receiver'=> 'email' },
  receivers => [ 
                 {
                   'name' => 'email',
                   'email_configs'=> [ 
                                     {
                     'to'   => 'pmajer@hsoftware.cz',
                     'from' => 'prometheus@hsoftware.cz',
                     'smarthost' => 'mail.hsoftware.cz',
                                     }
                                    ]
                 }
               ],
}

class { 'prometheus::node_exporter':
  version => '0.18.1',
  collectors_disable => ['bcache','bonding', 'conntrack', 'mdadm' ],
}

class { 'prometheus::blackbox_exporter':
  modules => {
               'http_2xx' => {
                               'prober' => 'http',
                               'timeout' => '2s',
               }
             },
}

class { 'prometheus::snmp_exporter':
}
