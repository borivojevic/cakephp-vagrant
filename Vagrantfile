# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	# Vagrant virtual environment running an Ubuntu 10.04 box
	config.vm.box = "precise64"
	config.vm.box_url = "http://files.vagrantup.com/precise64.box"

	# Boot with a GUI for easy debugging
	# Turn off when no necessary
	# config.vm.boot_mode = :gui

	config.vm.hostname  = "dev.mirkoborivojevic.localhost"
	config.vm.network :private_network, ip: "33.33.33.10"
	config.vm.network :forwarded_port, guest: 80, host: 8888

	# Share an additional folder to the guest VM. The first argument is
	# an identifier, the second is the path on the guest to mount the
	# folder, and the third is the path on the host to the actual folder.
	# config.vm.share_folder "v-data", "/vagrant_data", "../data"

	# Support symbolic linking in VirtualBox shared folders
	config.vm.provider "virtualbox" do |v|
		v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
	end

	# Enable and configure the puppet provisioner
	config.vm.provision :puppet do |puppet|
		puppet.manifests_path = "puppet/manifests"
		puppet.manifest_file = "default.pp"
		puppet.module_path = "puppet/modules"
	end
end
