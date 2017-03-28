class hbase::config ( $hbase_version, $hbase_cluster, $hbase_role ) {

  $hbase_regionservers = query_nodes("hbase.installed=true and hbase.cluster=${hbase_cluster} and hbase.role='regionserver'")

  file { '/etc/hbase/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'hbase',
    mode   => '0750',
  } ->

  file { '/etc/hbase/conf/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'hbase',
    mode   => '0750',
  }


  file { '/etc/hbase/conf/.cluster':
    ensure  => 'file',
    content => $hbase_cluster,
    require => File['/etc/hbase/conf/'],
  }

  file { '/etc/hbase/conf/.role':
    ensure  => 'file',
    content => $hbase_role,
    require => File['/etc/hbase/conf/'],
  }

  file { '/etc/hbase/conf/hadoop-metrics2-hbase.properties':
    ensure  => 'file',
    owner   => 'root',
    group   => 'hbase',
    mode    => '0640',
    content => template("hbase/${hbase_version}/hadoop-metrics2-hbase.properties.erb"),
    require => File['/etc/hbase/conf/'],
  }

  file { '/etc/hbase/conf/hbase-env.sh':
    ensure  => 'file',
    owner   => 'root',
    group   => 'hbase',
    mode    => '0640',
    content => template("hbase/${hbase_version}/hbase-env.sh.erb"),
    require => File['/etc/hbase/conf/'],
  }

  file { '/etc/hbase/conf/hbase-policy.xml':
    ensure  => 'file',
    owner   => 'root',
    group   => 'hbase',
    mode    => '0640',
    content => template("hbase/${hbase_version}/hbase-policy.xml.erb"),
    require => File['/etc/hbase/conf/'],
  }

  file { '/etc/hbase/conf/hbase-site.xml':
    ensure  => 'file',
    owner   => 'root',
    group   => 'hbase',
    mode    => '0640',
    content => template("hbase/${hbase_version}/hbase-site.xml.erb"),
    require => File['/etc/hbase/conf/'],
  }

  file { '/etc/hbase/conf/log4j.properties':
    ensure  => 'file',
    owner   => 'root',
    group   => 'hbase',
    mode    => '0640',
    content => template("hbase/${hbase_version}/log4j.properties.erb"),
    require => File['/etc/hbase/conf/'],
  }

  file { '/etc/hbase/conf/regionservers':
    ensure  => 'file',
    owner   => 'root',
    group   => 'hbase',
    mode    => '0640',
    content => template("hbase/${hbase_version}/regionservers.erb"),
    require => File['/etc/hbase/conf/'],
  }

}
