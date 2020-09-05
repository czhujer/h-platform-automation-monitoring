#
user { 'hpa-remote-executor':
  ensure     => 'present',
  comment    => 'user for remote exec',
  managehome => true,
}

ssh_authorized_key { 'cc-server@hpa-hq1':
  user => 'hpa-remote-executor',
  type => 'ssh-rsa',
  options => [ 'no-port-forwarding', 'no-X11-forwarding', 'no-agent-forwarding', 'command="/usr/local/bin/ssh_command_wrapper"' ],
  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQC9FpCgANLCOdTIep9sUBkwmuJ7l42zd+8PW5iKqROYt4oRfv6FFrztybUe+lBQh0hGjRi43J72DUCP6yCdODOSVZFCeLPlRkZrZjWDbLoGhyn0Xj7/Zz8GqV0o01+LxYKfGvR6wRxRp8Iz3+xP0PoOGkj4359BLxX9qYB7BNga23jgHb2iak7HrdZma738IRa7v3enO8hD8RYYvBnCPEl4iuH/q+8jtCEWStYbiFVKePNaki/l1DLxzu9CEY+XlswiS17bQxtpcrsP3yn9x4LKTkdqFYA4wkDuJVYZfLRKSFDWKhPJl7udSB6nskmf5WW056y9b9v2r/U525Sw5BNICZmwkXwR/shf9MsE+xYyh1zTb+50YPxXDW+lRVeiAGnCixFxndiFZLppQ/sgGWZcohNir3F/m9Drakei7AbJUn6k1nhBG4TzfQrTzXWu4EwnKupQvi80+AqzQ5WkUXSeqwYyR/I5M+Biv25NFUkvTanfXPNz5YMufECpCtFlg8n36Y7KBUy4dhQ3Et7eyrOYOQbHDnnFp6Zm5ECP7LEILikgqAz2BnPQE5qIYb+X45j572tTTETmBI8OT5tn/zh9pikNdHzGoZsvBu4g/zgfjtud+eJxLR4jw+zbVqtQ65W/11ZEpSLQm9MogCalkjl0e8jaUriPkTRmWrgM93TvaQ==',
  require => User['hpa-remote-executor'],
}

$ssh_command_wrapper_content = '#!/bin/bash
shopt -s extglob

#
# You can have only one forced command in ~/.ssh/authorized_keys. Use this
# wrapper to allow several commands.

case "$SSH_ORIGINAL_COMMAND" in
    "prom-file-sd-node-ocb2c oc-"[0-9][0-9][0-9].@(cust.hcloud.cz|hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/create_prom_config_for_file_sd.sh prom-file-sd-node-ocb2c $SSH_ORIGINAL_COMMAND
        ;;
    "prom-file-sd-mysql-ocb2c oc-"[0-9][0-9][0-9].@(cust.hcloud.cz|hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/create_prom_config_for_file_sd.sh prom-file-sd-mysql-ocb2c $SSH_ORIGINAL_COMMAND
        ;;
    "prom-file-sd-apache-ocb2c oc-"[0-9][0-9][0-9].@(cust.hcloud.cz|hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/create_prom_config_for_file_sd.sh prom-file-sd-apache-ocb2c $SSH_ORIGINAL_COMMAND
        ;;
    "prom-file-sd-redis-ocb2c oc-"[0-9][0-9][0-9].@(cust.hcloud.cz|hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/create_prom_config_for_file_sd.sh prom-file-sd-redis-ocb2c $SSH_ORIGINAL_COMMAND
        ;;
    "prom-file-sd-php-fpm-ocb2c oc-"[0-9][0-9][0-9].@(cust.hcloud.cz|hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/create_prom_config_for_file_sd.sh prom-file-sd-php-fpm-ocb2c $SSH_ORIGINAL_COMMAND
        ;;
    "prom-file-sd-node-ocb2c-remove oc-"[0-9][0-9][0-9]*(.cust.hcloud.cz|.hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/remove_prom_config_for_file_sd.sh prom-file-sd-node-ocb2c-remove $SSH_ORIGINAL_COMMAND
        ;;
    "prom-file-sd-mysql-ocb2c-remove oc-"[0-9][0-9][0-9]*(.cust.hcloud.cz|.hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/remove_prom_config_for_file_sd.sh prom-file-sd-mysql-ocb2c-remove $SSH_ORIGINAL_COMMAND
        ;;
    "prom-file-sd-apache-ocb2c-remove oc-"[0-9][0-9][0-9]*(.cust.hcloud.cz|.hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/remove_prom_config_for_file_sd.sh prom-file-sd-apache-ocb2c-remove $SSH_ORIGINAL_COMMAND
        ;;
    "prom-file-sd-redis-ocb2c-remove oc-"[0-9][0-9][0-9]*(.cust.hcloud.cz|.hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/remove_prom_config_for_file_sd.sh prom-file-sd-redis-ocb2c-remove $SSH_ORIGINAL_COMMAND
        ;;
    "prom-file-sd-php-fpm-ocb2c-remove oc-"[0-9][0-9][0-9]*(.cust.hcloud.cz|.hcloud.cz))
        echo "INFO: $SSH_ORIGINAL_COMMAND"
        sudo /root/remove_prom_config_for_file_sd.sh prom-file-sd-php-fpm-ocb2c-remove $SSH_ORIGINAL_COMMAND
        ;;
    *)
        echo "Access denied"
        echo "$SSH_ORIGINAL_COMMAND"
        exit 1
        ;;
esac
'

file { '/usr/local/bin/ssh_command_wrapper':
  ensure => present,
  mode   => '0755',
  content => $ssh_command_wrapper_content,
}

$create_prom_config_for_file_sd = '#!/bin/bash

if [ "$3" = "" ]; then
  # with out sudo
  command="$1"
  target="$2"
else
  # with sudo
  command="$2"
  target="$3"
fi;

if [[ $command =~ ^prom-file-sd-(node|mysql|apache|redis|php-fpm)-ocb2c$ ]]; then
   label=${BASH_REMATCH[1]}
   real_command="$command"
   dst_folder="/etc/prometheus_sd_file/ocb2c"
else
  echo "ERROR: unsupported command!";
  exit 1;
fi;

if [ "$target" = "" ]; then
  echo "ERROR: missing target variable!"
  exit 2;
fi;

echo "INFO: command: $real_command target: $target";

cat << EOF > ${dst_folder}/${label}-${target}.yml
---
-
  labels:
    job: ${label}
  targets:
    - \'${target}\'
EOF

exit $?;
'

file { '/root/create_prom_config_for_file_sd.sh':
  ensure => present,
  mode   => '0755',
  content => $create_prom_config_for_file_sd,
}

$remove_prom_config_for_file_sd = '#!/bin/bash

if [ "$3" = "" ]; then
  # with out sudo
  command="$1"
  target="$2"
else
  # with sudo
  command="$2"
  target="$3"
fi;

if [[ $command =~ ^prom-file-sd-(node|mysql|apache|redis|php-fpm)-ocb2c-remove$ ]]; then
  label=${BASH_REMATCH[1]}
  real_command="prom-file-sd-${label}-ocb2c-remove"
  dst_folder="/etc/prometheus_sd_file/ocb2c"
else
  echo "ERROR: unsupported command!";
  exit 1;
fi;

if [ "$target" = "" ]; then
  echo "ERROR: missing target variable!"
  exit 2;
fi;

echo "INFO: command: $real_command target: $target";

rm -rf ${dst_folder}/${label}-${target}.*.yml

exit $?;
'

file { '/root/remove_prom_config_for_file_sd.sh':
  ensure => present,
  mode   => '0755',
  content => $remove_prom_config_for_file_sd,
}

$sudo_create_prom_config_for_file_sd="#\nDefaults:hpa-remote-executor !requiretty\n#\nhpa-remote-executor  ALL=(ALL)  NOPASSWD: /root/create_prom_config_for_file_sd.sh\n"

file {"hpa-remote-executor allow create_prom_config_for_file_sd":
    path => "/etc/sudoers.d/hpa-remote-executor-create_prom_config_for_file_sd",
    ensure  => present,
    content => $sudo_create_prom_config_for_file_sd,
}

$sudo_remove_prom_config_for_file_sd="#\nDefaults:hpa-remote-executor !requiretty\n#\nhpa-remote-executor  ALL=(ALL)  NOPASSWD: /root/remove_prom_config_for_file_sd.sh\n"

file {"hpa-remote-executor allow remove_prom_config_for_file_sd":
    path => "/etc/sudoers.d/hpa-remote-executor-remove_prom_config_for_file_sd",
    ensure  => present,
    content => $sudo_remove_prom_config_for_file_sd,
}
