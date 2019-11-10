#

ssh_authorized_key { 'hpa-hq1@jenkins':
  user => 'hpa-remote-executor',
  type => 'ssh-rsa',
  options => [ 'no-port-forwarding', 'no-X11-forwarding', 'no-agent-forwarding', 'command="/usr/local/bin/ssh_command_wrapper"' ],
  #key  => '',
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
