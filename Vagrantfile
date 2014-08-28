Vagrant.configure("2") do |config|

  # Enable the Puppet provisioner, with will look in manifests
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "init.pp"
    puppet.options = ["--templatedir","/vagrant/templates"]
  end

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

end
