# ::dataloop_agent::repo - configure dataloop agent repositories
class dataloop_agent::repo(
  $gpg_key_url = 'https://download.dataloop.io/pubkey.gpg',
  $release = 'stable',
  ) {

  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'SL', 'SLC', 'Ascendos',
    'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL', 'Amazon', 'XenServer': {
  
      yumrepo { 'dataloop':
        baseurl  => "https://download.dataloop.io/packages/${release}/el\$releasever/${::architecture}",
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
      require ::apt
      apt::key { 'dataloop':
        id     => '095E8A4D6D9018DD45BD8E870008AA66113E2B8D',
        source => $gpg_key_url,
      }
      apt::source { 'dataloop':
        location => 'https://download.dataloop.io/deb',
        release  => $release,
        repos    => 'main',
        require  => Apt::Key['dataloop'],
      }
    }
    default: {
      warning("Module ${module_name} is not supported on ${::lsbdistid}")
    }
  }

}

