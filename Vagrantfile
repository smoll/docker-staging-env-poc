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

      # Only run this provisioner on the first 'vagrant up'
      if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
        # Install Docker
        pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
          "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
          "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; "
        # Add vagrant user to the docker group
        pkg_cmd << "usermod -a -G docker vagrant; "
        host.vm.provision :shell, :inline => pkg_cmd
      end

      # To not run provisioners, do: vagrant up --no-provision
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
