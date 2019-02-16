# -*- mode: ruby -*-
# vi: set ft=ruby :

# Define virtual machines
nodes = [
	{
	:name => "jenkins",
	:ip => "192.168.1.21",
	:mem => "4096",
	:cpu => "2"
	}
]

# Define shell scripts
# Generate SSH key, disable host key checking and copy to file in synced folder
$generate_ssh_key = <<-SCRIPT
su -c 'echo -e "\n\n\n" | ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa' - vagrant
echo -e "Host *\n    StrictHostKeyChecking no" > /home/vagrant/.ssh/config
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  nodes.each do |node|
    config.vm.define node[:name] do |config|
      # Configure nodes networking and resources
      config.vm.hostname = node[:name]
      config.vm.provider "virtualbox" do |vb|
        vb.memory = node[:mem]
        vb.cpus = node[:cpu]
      end
      config.vm.network :public_network, ip: node[:ip]
      # Enable SSH password authentication on all nodes
      config.vm.provision "shell", inline: 'sudo sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config && sudo service sshd restart'
	  # Generate SSH key and disable host key checking
      config.vm.provision "shell", inline: $generate_ssh_key
	  # Install Ansible
	  config.vm.provision "shell", inline: 'sudo apt-get update -y && sudo apt-get install -y software-properties-common && sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update -y && sudo apt-get install -y ansible'
    end
  end
end
