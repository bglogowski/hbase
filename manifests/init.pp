class hbase (
    String  $hbase_version   = '1.1.9',
    String  $hbase_cluster   = 'default',
    Array   $hbase_role      = [ 'master', 'regionserver' ],
    Boolean $install_phoenix = true,
    String  $phoenix_version = '4.8.2'
  ) {

  [ 'hbase' ].each |String $user| {

    hbase::users { $user:
      username      => $user,
      hbase_cluster => $hbase_cluster,
      before        => Class['hbase::install'],
    }

  }

  class { 'hbase::install':
    hbase_version   => $hbase_version,
    install_phoenix => $install_phoenix,
    phoenix_version => $phoenix_version,
    before          => Class['hbase::config'],
  }

  class { 'hbase::config':
    hbase_version => $hbase_version,
    hbase_cluster => $hbase_cluster,
  }

  $hbase_role.each |String $role| {

    hbase::role::assign { $role:
      hbase_role => $role,
      require    => Class['hadoop::config'],
    }

  }

}
