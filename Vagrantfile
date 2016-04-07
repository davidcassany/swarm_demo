# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # config.vm.box = "base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  ## Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  # Introduced by myself
  swarm_token = "deadbeefdeadbeefdeadbeefdeadbeef"
  node0_ip = "192.168.56.200"
  node1_ip = "192.168.56.201"
  

  config.vm.define "node1" do |node1|
    node1.vm.box = "alienscience/openSUSE-Leap-42.1"
    node1.vm.hostname = 'node1'
    node1.vm.box_url = "alienscience/openSUSE-Leap-42.1"
    node1.vm.network :private_network, ip: node1_ip
    node1.vm.communicator = "ssh"

    # unfortunately docker provisioner is not supported on suse
=begin
    node1.vm.provision "shell", inline: 'echo \'DOCKER_OPTS=\"-H tcp://0.0.0.0:2375\"\' > /etc/sysconfig/docker'
    node1.vm.provision "docker" do |d|
      d.build_image "/vagrant/dataBase", args: "-t david/db"
      d.build_image "/vagrant/webapp", args: "-t david/webapp"
      d.run "swarm" ,
        cmd: "join --addr=#{node1_ip}:2375 token://#{swarm_token}",
        restart: "unless-stopped",
        args: "-d"
    end
=end

    # Manually added docker, builds and swarm agent
    node1.vm.provision :shell, path: "swarm_agent.sh", :args => "#{node1_ip} #{swarm_token}"

    node1.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "node1"]
    end
  end

  config.vm.define "node0" do |node0|
    node0.vm.box = "alienscience/openSUSE-Leap-42.1"
    node0.vm.hostname = 'node0'
    node0.vm.box_url = "alienscience/openSUSE-Leap-42.1"
    node0.vm.network :private_network, ip: node0_ip
    node0.vm.communicator = "ssh"

    node0.vm.provision :shell, path: "swarm_agent.sh", :args => "#{node0_ip} #{swarm_token}"
    #node0.vm.provision :shell, inline: "docker run --restart unless-stopped -d -p 23755:2375 swarm manage token://#{swarm_token}"

    node0.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "node0"]
    end
  end

  config.vm.define "manager" do |a|
    ENV['DOCKER_HOST'] = ""
    a.vm.provider "docker" do |d|
      d.image = "swarm"
      d.name = "swarm-manager"
      d.cmd = ["swarm", "manage token://#{swarm_token}"]
      d.ports = ["23755:2375"]
      d.remains_running = true
    end
  end

  config.vm.define "db" do |b|
    ENV['DOCKER_HOST'] = "tcp://localhost:23755"
    b.vm.provider "docker" do |d|
      d.image = "david/db"
      d.name = "db"
      d.remains_running = true
    end
  end
 
  config.vm.define "webapp" do |a|
    ENV['DOCKER_HOST'] = "tcp://localhost:23755"
    a.vm.provider "docker" do |d|
      d.image = "david/webapp"
      d.name = "webapp"
      d.remains_running = true
      d.link("db:mongodbd")
      d.ports = [ "3000:3000" ]
    end
  end

end

