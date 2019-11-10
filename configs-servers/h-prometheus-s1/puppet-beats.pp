class { 'beats':
    outputs_deep_merge => false,
    outputs_logstash => {
      "filebeat" => { "hosts" => [ "h-logstash:5045" ],
                                   "use_tls" => false,
                                   "version_v5" => true,
                    },
    },
    version_v5 => true,
    #agentname   => 'h-prometheus-s1',
}

class { 'beats::filebeat':
    version_v5  => true,
    prospectors => {
             # 'syslog' => {
             #     'document_type' => "syslog",
             #     'paths'  => [ "/var/log/messages",
             #                   "/var/log/secure",
             #                   "/var/log/yum.log",
             #                   "/var/log/cron",
             #                   "/var/log/maillog",
             #                   "/var/log/ntp",
             #                   "/var/log/zabbix/zabbix_agentd2.log",
             #                 ],
             # },
              # 'others'   => {
              #     "document_type" => "others",
              #     'paths'  => [
              #                     "/var/log/jenkins-slave/jenkins-slave.log",
              #                     "/var/log/zabbix/zabbix_agentd.log",
              #                 ],
              # },
              'nginx-error'  => {
                  'document_type' => "nginx-error",
                  'paths'  => [
                                  "/var/log/nginx/*.error.log",
                                 "/var/log/nginx/error.log",
                              ],
              },
              'nginx-access'  => {
                  'document_type' => "nginx-access",
                  'paths'  => [
                                 "/var/log/nginx/*.access.log",
                                 "/var/log/nginx/access.log",
                              ],
              },
              'grafana'  => {
                  'document_type' => "grafana",
                  'paths'  => [
                                 "/var/log/grafana/grafana.log",
                              ],
              },
              'tuned'  => {
                  'document_type' => 'tuned',
                  'paths'  => [
                                 "/var/log/tuned/tuned.log",
                              ],
              },
    },
}
