Vagrant.configure("2") do |config|
  config.ssh.forward_agent = true
  config.vm.define "demo" do |host_config|
    host_config.vm.box = 'official_trusty64'
    host_config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  end

  # Enable the Puppet provisioner, with will look in manifests
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "./manifests"
    puppet.module_path = "./modules"
    puppet.manifest_file = "default.pp"
  end
end
