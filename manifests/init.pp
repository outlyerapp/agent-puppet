# ::dataloop_agent - provision dataloop agent
class dataloop_agent(
  $ensure = 'running',
  $enable = true,
  $install_opts = $::dataloop_agent::repo::install_options,
  $solo_mode = 'no',
  $debug = 'no',
  $api_key = 'changeme',
  $dataloop_server = 'wss://agent.dataloop.io',
  $agent_version = 'latest',
  $deregister_onstop = false,
  $tags = false,
  $agent_name = false,
  ) inherits ::dataloop_agent::repo {

  contain ::dataloop_agent::repo

  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'SL', 'SLC', 'Ascendos',
    'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL', 'Amazon', 'XenServer': {
      $init_path = '/etc/sysconfig/dataloop-agent'
      package { 'dataloop-agent':
        ensure          => $agent_version,
        install_options => $install_opts,
        require         => Class['dataloop_agent::repo'],
      }
      service { 'dataloop-agent':
        ensure => $ensure,
        enable => $enable,
      }
    }
    'Debian', 'Ubuntu': {
      $init_path = '/etc/default/dataloop-agent'
      package { 'dataloop-agent':
        ensure          => $agent_version,
        install_options => $install_opts,
        require         => [ Exec['apt_update'], Apt::Source['dataloop'] ],
      }
      service { 'dataloop-agent':
        ensure     => $ensure,
        enable     => $enable,
        hasstatus  => true,
        hasrestart => true,
      }
    }
    default: {
      warning("Module ${module_name} is not supported on ${::lsbdistid}")
    }
  }

  if ($deregister_onstop) {
    file { $init_path:
      ensure  => present,
      content => template('dataloop_agent/agent.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0760',
      notify  => Service['dataloop-agent'],
      require => Package['dataloop-agent'],
    }
  }

  file { '/etc/dataloop/agent.yaml':
    ensure  => 'present',
    content => template('dataloop_agent/agent.yaml.erb'),
    owner   => 'root',
    group   => 'dataloop',
    mode    => '0640',
    notify  => Service['dataloop-agent'],
    require => Package['dataloop-agent'],
  }

  file { '/etc/logrotate.d/dataloop':
    ensure  => 'present',
    source  => 'puppet:///modules/dataloop_agent/dataloop.logrotate',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['dataloop-agent'],
  }

}
