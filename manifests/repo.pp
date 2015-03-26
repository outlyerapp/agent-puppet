class dataloop_agent::repo() {

  case $::operatingsystem {
   'RedHat', 'CentOS', 'Fedora', 'Scientific', 'SL', 'SLC', 'Ascendos',
   'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL', 'Amazon', 'XenServer': {
  
      yumrepo { 'dataloop':
        baseurl  => "https://download.dataloop.io/packages/stable/rpm/$architecture",
        descr    => 'Dataloop Repository',
        enabled  => 1,
        # GPG is disabled until packages are GPG signed
        gpgcheck => 0,
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

      $apt_key_url = 'https://download.dataloop.io/pubkey.gpg'

      exec { 'apt-key dataloop':
        command => "/usr/bin/wget -q ${apt_key_url} -O -|/usr/bin/apt-key add -",
        unless  => '/usr/bin/apt-key list|/bin/grep -c dataloop',
      }
  
      apt::source { 'dataloop':
        location    => 'https://download.dataloop.io/deb',
        release     => 'stable',
        repos       => 'main',
        include_src => false,
      }
    }
  }

}

