class hbase::users ( $hbase_cluster ) {

  $hbase_rsa_2048_keys = query_facts("hbase.installed=true and hbase.cluster=${hbase_cluster}", ["hbase.rsa_2048_key"])

  group { 'hbase':
    ensure => 'present',
    gid    => '5000',
  }

  user { 'hbase':
    ensure   => 'present',
    comment  => 'HBase Service User',
    uid      => '5000',
    gid      => '5000',
    home     => '/home/hbase',
    password => '!',
    shell    => '/bin/bash',
    require  => Group['hbase'],
  }

  file { '/home/hbase/':
    ensure  => 'directory',
    owner   => 'hbase',
    group   => 'hbase',
    mode    => '0750',
    require => User['hbase'],
  }

  file { '/home/hbase/.bashrc':
    ensure  => 'present',
    owner   => 'hbase',
    group   => 'hbase',
    mode    => '0755',
    backup  => false,
    source  => "puppet:///modules/hbase/bashrc",
    require => File['/home/hbase/'],
  } ->

  file { '/home/hbase/.bash_profile':
    ensure  => 'link',
    target  => '/home/hbase/.bashrc',
    require => File['/home/hbase/.bashrc'],
  }

  file { '/home/hbase/.ssh/':
    ensure  => 'directory',
    owner   => 'hbase',
    group   => 'hbase',
    mode    => '0700',
    require => File['/home/hbase/'],
  }

  file { '/home/hbase/.ssh/authorized_keys':
    ensure  => 'file',
    owner   => 'hbase',
    group   => 'hbase',
    mode    => '0640',
    content => template('hbase/authorized_keys.erb'),
    require => File['/home/hbase/.ssh/'],
  }

  exec { 'hbase ssh-keygen':
    command => '/bin/su -l hbase -c \'/usr/bin/ssh-keygen -t rsa -b 2048 -f /home/hbase/.ssh/id_rsa -N ""\'',
    creates => '/home/hbase/.ssh/id_rsa',
    require => File['/home/hbase/.ssh/'],
  }

}
