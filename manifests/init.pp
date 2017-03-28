class hbase (
    $hbase_version   = '1.1.9',
    $hbase_cluster   = 'default',
    $hbase_role      = 'regionserver',
    $install_phoenix = true,
    $phoenix_version = '4.8.2'
  ) {

    class { 'hbase::users':
      hbase_cluster => $hbase_cluster,
    } ->

    class { 'hbase::install':
      hbase_version   => $hbase_version,
      install_phoenix => $install_phoenix,
      phoenix_version => $phoenix_version,
    } ->

    class { 'hbase::config':
      hbase_version => $hbase_version,
      hbase_cluster => $hbase_cluster,
      hbase_role    => $hbase_role,
    }

}
