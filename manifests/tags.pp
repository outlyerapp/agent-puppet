# initialize dataloop agent::tags

class dataloop_agent::tags{

  $tag_filename = "/etc/dataloop/tags.conf"
  $tags = join(hiera('dataloop_agent::tags'),',')

  file { 'tags.conf':
    replace => 'yes',
    name    => $tag_filename,
    ensure  => present,
    mode    => 0640,
    content => "${tags}\n",
    owner   => 'dataloop',
    require => Service["dataloop-agent"],
    notify  => Exec['clear dataloop tags']
  }

  exec { 'clear dataloop tags':
    command     => "dataloop-agent -a ${dataloop_agent::api_key} --clear-tags -d",
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    user        => 'dataloop',
    refreshonly => true,
    notify      => Exec["install dataloop tags ${tags}"]
  }
  exec { "install dataloop tags ${tags}":
    command     => "dataloop-agent -a ${dataloop_agent::api_key} --add-tags ${tags} -d",
    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    user        => 'dataloop',
    refreshonly => true
  }

}
