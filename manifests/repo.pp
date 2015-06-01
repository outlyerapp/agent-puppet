class dataloop_agent::repo(
  $gpg_key_url = 'https://download.dataloop.io/pubkey.gpg',
  $release = 'stable',
  ) {

  case $::operatingsystem {
   'RedHat', 'CentOS', 'Fedora', 'Scientific', 'SL', 'SLC', 'Ascendos',
   'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL', 'Amazon', 'XenServer': {
  
      yumrepo { 'dataloop':
        baseurl  => "https://download.dataloop.io/packages/${release}/rpm/$architecture",
        descr    => 'Dataloop Repository',
        enabled  => 1,
        gpgkey   => $gpg_key_url,
        gpgcheck => 1,
      }

      exec { 'clean_yum_metadata':
        command     => '/usr/bin/yum clean metadata',
        refreshonly => true,
        require     => Yumrepo['dataloop'],
      }

    }
   'Debian', 'Ubuntu': {
    include apt
    include apt::update


      exec { 'apt-key dataloop':
        command => "/usr/bin/wget -q ${gpg_key_url} -O -|/usr/bin/apt-key add -",
        unless  => '/usr/bin/apt-key list|/bin/grep -c dataloop',
      }
  
      apt::source { 'dataloop':
        location    => 'https://download.dataloop.io/deb',
        release     => $release,
        repos       => 'main',
        include_src => false,
        require     => Exec['apt-key dataloop'],
      }
    }
  }

}

