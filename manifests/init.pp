# initialize dataloop agent

class dataloop_agent(

  $install_opts = $::dataloop_agent::repo::install_options,
  $api_key = 'changeme',
  $agent_version = 'latest',
  $tags = ['all']
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
  
  service { 'dataloop-agent':
    ensure => running,
    enable => true,
  }

  #############
  # tagging
  #############

  $tag_filename = "/etc/dataloop/tags.conf"
  $tags_merged = join($tags,',')

  file { 'tags.conf':
    replace => 'yes',
    name    => $tag_filename,
    ensure  => present,
    mode    => 0640,
    content => "${$tags_merged}\n",
    owner   => 'dataloop',
    require => Service["dataloop-agent"],
    notify  => Exec['clear dataloop tags']
  }

  exec { 'clear dataloop tags':
    command     => "dataloop-agent -a ${dataloop_agent::api_key} --clear-tags -d",
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    user        => 'dataloop',
    refreshonly => true,
    notify      => Exec["install dataloop tags ${$tags_merged}"]
  }
  exec { "install dataloop tags ${$tags_merged}":
    command     => "dataloop-agent -a ${dataloop_agent::api_key} --add-tags ${$tags_merged} -d",
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    user        => 'dataloop',
    refreshonly => true
  }

}
