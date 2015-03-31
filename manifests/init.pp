class dataloop_agent(
  $install_opts = $::dataloop_agent::repo::install_options,
  $solo_mode = 'no',
  $debug = 'no',
  $api_key = 'changeme',
  $agent_version = 'latest',
  $deregister_onstop = false,
  $tags = false,
  $agent_name = false,
  ) inherits ::dataloop_agent::repo {

  package { 'dataloop-agent':
    ensure => $agent_version,
    install_options => $install_opts,
    require => Class['dataloop_agent::repo'],
  }

  if ($deregister_onstop) {
    case $::operatingsystem {
     'RedHat', 'CentOS', 'Fedora', 'Scientific', 'SL', 'SLC', 'Ascendos',
     'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL', 'Amazon', 'XenServer': {
       $init_path = '/etc/sysconfig/dataloop-agent'
     }
     'Debian', 'Ubuntu': {
       $init_path = '/etc/default/dataloop-agent'
     }
    }
  
      file { $init_path:
        ensure  => present,
        content => template('dataloop_agent/agent.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0760',
        notify   => Service['dataloop-agent'],
        require  => Package['dataloop-agent'],
      }
  }
  
  file { '/etc/dataloop/agent.yaml':
    ensure  => 'present',
    content => template("dataloop_agent/agent.yaml.erb"),
    owner   => 'dataloop',
    group   => 'dataloop',
    mode    => '0600',
    notify   => Service['dataloop-agent'],
    require  => Package['dataloop-agent'],
  }

  file { '/etc/logrotate.d/dataloop':
    ensure  => 'present',
    content => 'puppet:///modules/dataloop_agent/dataloop.logrotate',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require  => Package['dataloop-agent'],
  }
  
  service { 'dataloop-agent':
    ensure => running,
    enable => true,
  }
}
