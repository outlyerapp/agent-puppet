class dataloop_agent(
  $install_opts = $::dataloop_agent::repo::install_options,
  $api_key = 'changeme',
  $agent_version = 'latest',
  $manage_init = false,
  $deregister_onstop = false,
  ) inherits ::dataloop_agent::repo {

  package { 'dataloop-agent':
    ensure => $agent_version,
    install_options => $install_opts,
    require => Class['dataloop_agent::repo'],
  }
  
  file { '/etc/dataloop/agent.conf':
    ensure  => 'present',
    content => template("dataloop_agent/agent.conf.erb"),
    owner   => 'dataloop',
    group   => 'dataloop',
    mode    => '0600',
    notify   => Service['dataloop-agent'],
    require  => Package['dataloop-agent'],
  }
  
  if ($manage_init) {
    case $::operatingsystem {
     'RedHat', 'CentOS', 'Fedora', 'Scientific', 'SL', 'SLC', 'Ascendos',
     'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL', 'Amazon', 'XenServer': {
       
       $init_template = 'dataloop_agent/dataloop-agent-rpm.erb'
     }
     'Debian', 'Ubuntu': {
       $init_template = 'dataloop_agent/dataloop-agent-deb.erb'
     }
    }

      file { '/etc/init.d/dataloop-agent':
        ensure  => present,
        content => template($init_template),
        owner   => 'root',
        group   => 'root',
        mode    => '0760',
      }
  }
  
  service { 'dataloop-agent':
    ensure => running,
    enable => true,
  }
}
