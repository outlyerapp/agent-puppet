class dataloop_agent(
  $install_opts = $::dataloop_agent::repo::install_options,
  $api_key = 'changeme',
  $agent_version = 'latest'
  ) inherits ::dataloop_agent::repo {
  
  include dataloop_agent::tags

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
  
  service { 'dataloop-agent':
    ensure => running,
    enable => true,
  }
}
