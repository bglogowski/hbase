define hbase::role::assign ( String $hbase_role ) {

  if $facts['os']['family'] == 'RedHat' {
    $system_dir = '/usr/lib/systemd/system/'
  } else {
    $system_dir = '/lib/systemd/system/'
  }

  file { "/etc/hbase/conf/.${hbase_role}":
    ensure  => 'file',
    owner   => 'root',
    group   => 'hbase',
    mode    => '0640',
    require => File['/etc/hbase/conf/'],
  }

  file { "hbase-${hbase_role}.service":
    ensure  => 'file',
    path    => "${system_dir}/hbase-${hbase_role}.service",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("hbase/${hbase_role}/hbase-${hbase_role}.service.erb"),
  }

  service { "hbase-${hbase_role}":
    ensure  => 'stopped',
    enable  => false,
    require => File["hbase-${hbase_role}.service"],
  }

}
