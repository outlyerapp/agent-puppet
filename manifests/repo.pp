class dataloop_agent::repo() {

  case $::operatingsystem {
    
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'SL', 'SLC', 'Ascendos',
    'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL', 'Amazon', 'XenServer': {
  
      yumrepo { 'dataloop':
        baseurl => "https://download.dataloop.io/packages/stable/rpm/$architecture",
        descr => 'Dataloop Repository',
        enabled => 1,
        # GPG is disabled until packages are GPG signed
        gpgcheck => 0,
      }

      exec { "clean_yum_metadata":
        command => "/usr/bin/yum clean metadata",
        refreshonly => true,
        require => Yumrepo['dataloop'],
      }

    }

    'Debian', 'Ubuntu': {
    include apt
    
  
      apt::source { 'dataloop':
        location    => 'https://download.dataloop.io/packages/stable/deb/',
        release     => 'x86_64/',
        repos       => '',
        include_src => false,
      }
      # this is an override until packages are GPG signed
      $install_options = [ '--force-yes' ]
    }
  }

}
