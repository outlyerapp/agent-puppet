class dataloop (
   $version = '0.020',
   $apikey = 'changeme',
   $all_tags = 'all',
   $user = 'dataloop',
) {

  user { $user:
    ensure   => present,
    password => undef,
    notify   => Exec['fetch_agent'],
  }

  exec { 'fetch_agent':
    command  => "wget -q -O /usr/local/bin/dataloop-lin-agent https://download.dataloop.io/linux/v${version}/dataloop-lin-agent",
    notify   => Exec['fix_permissions'],
  }

  exec { 'fix_permissions':
    command => "chmod +x /usr/local/bin/dataloop-lin-agent",
    notify  => File['/etc/init.d/dataloop-agent'],
  }

  file { '/etc/init.d/dataloop-agent':
    ensure  => 'present',
    content => template('dataloop/dataloop-agent.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    notify   => Service['dataloop-agent'],
  }

  file { '/var/log/dataloop':
    ensure => 'directory',
    owner  => $user,
    group  => $user,
    mode   => '0755',
  }

  service { 'dataloop-agent':
    ensure => running,
    require  => File['/var/log/dataloop']
  }

}
