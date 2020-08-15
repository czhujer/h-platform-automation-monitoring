# archive { '/usr/lib64/libopentracing.so.1.6.0':
#   ensure        => present,
#   extract       => false,
#   extract_path  => '/tmp',
#   source        => '/vagrant/files/centos-7/libopentracing.so.1.6.0',
#   cleanup       => true,
#   before        => Class['nginx::service'],
# }
#
# file { '/usr/lib64/libopentracing.so.1.6.0':
#   ensure  => 'file',
#   mode    => '0755',
#   seltype => 'lib_t',
#   require => Archive['/usr/lib64/libopentracing.so.1.6.0'],
#   before  => Class['nginx::service'],
# }
#
# file { '/usr/lib64/libopentracing.so.1':
#   ensure  => 'link',
#   target  => '/usr/lib64/libopentracing.so.1.6.0',
#   require => Archive['/usr/lib64/libopentracing.so.1.6.0'],
# }
#
# file { '/usr/lib64/libopentracing.so':
#   ensure  => 'link',
#   target  => '/usr/lib64//libopentracing.so.1',
#   require => File['/usr/lib64/libopentracing.so.1'],
# }
#
# file { '/usr/lib64/libyaml-cppd.so.0.6.2':
#   ensure  => 'file',
#   mode    => '0755',
#   # selinux_ignore_defaults => false,
#   seltype => 'lib_t',
#   #require => Archive['/usr/lib64/libopentracing.so.1.6.0'],
#   before  => Class['nginx::service'],
# }
