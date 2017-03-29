class hbase::install ( $hbase_version, $install_phoenix, $phoenix_version ) {

  $mirror = lookup( "mirrors.apache.${fqdn_rand(10)}" )
  $checksum = lookup( 'checksums.hbase' )[$hbase_version]['sha256']

  if ($facts['hbase']['installed'] == true) and ($facts['hbase']['version'] == $hbase_version) {

    file {"/var/tmp/hbase-${hbase_version}-bin.tar.gz":
      ensure => 'absent',
      backup => false,
    }

    file { '/usr/local/bin/hbase':
      ensure => 'link',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      target => '/opt/hbase/bin/hbase',
    }

    if $install_phoenix == true {

      class { 'phoenix':
        hbase_version   => $hbase_version,
        phoenix_version => $phoenix_version,
      }

    }

  } else {

    file { "/var/tmp/hbase-${hbase_version}-bin.tar.gz":
      ensure         => 'present',
      owner          => 'root',
      group          => 'root',
      mode           => '0644',
      checksum       => 'sha256',
      checksum_value => $checksum,
      backup         => false,
      source         => "http://${mirror}/hbase/${hbase_version}/hbase-${hbase_version}-bin.tar.gz",
      notify         => Exec["untar hbase-${hbase_version}"],
    }

    exec { "untar hbase-${hbase_version}":
      command     => "/bin/tar xf /var/tmp/hbase-${hbase_version}-bin.tar.gz",
      cwd         => '/opt',
      refreshonly => true,
      require     => File["/var/tmp/hbase-${hbase_version}-bin.tar.gz"],
      notify      => Exec["chown hbase-${hbase_version}"],
    } ->

    exec { "chown hbase-${hbase_version}":
      command     => "/bin/chown -R root:root /opt/hbase-${hbase_version}",
      cwd         => '/opt',
      refreshonly => true,
      require     => File["/var/tmp/hbase-${hbase_version}-bin.tar.gz"],
    } ->

    file { '/opt/hbase':
      ensure  => 'link',
      target  => "/opt/hbase-${hbase_version}",
      require => File["/var/tmp/hbase-${hbase_version}-bin.tar.gz"],
    }

  }

}
