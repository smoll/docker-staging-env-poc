# From https://github.com/phusion/open-vagrant-boxes

$number_of_machines = 3

Vagrant.configure("2") do |config|
  # always use Vagrant's insecure key
  config.ssh.insert_key = false

  config.vm.box = "phusion-open-ubuntu-14.04-amd64"
  config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box"

  (1..$number_of_machines).each do |i|
    config.vm.define "host-#{i}" do |host|
      host.vm.hostname = "host-#{i}"
      # Hardcode IPs as 192.168.50.101, 192.168.50.102, etc. to make it easier to write
      # step-by-step directions in README.md
      host.vm.network "private_network", ip: "192.168.50.#{100 + i}"

      # See http://docs.ansible.com/ansible/guide_vagrant.html#running-ansible-manually
      config.vm.network :forwarded_port, guest: 22, host: 2200 + i, id: 'ssh'

      # To not run provisioners, do: vagrant up --no-provision

      # Install Docker & prereqs to deploying containers via Ansible
      config.vm.provision "ansible" do |ansible|
        ansible.verbose = "v"
        ansible.playbook = "ansible/common.yml"
        ansible.sudo = true
      end

      # Bootstrap consul cluster
      provisioner = if i == 1 # first
                      "provision/1.sh"
                    elsif i == $number_of_machines # last
                      "provision/3.sh"
                    else
                      "provision/2.sh"
                    end
      host.vm.provision "shell", path: provisioner
    end
  end
end
