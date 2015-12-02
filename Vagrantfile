Vagrant.configure("2") do |config|
  config.vm.box = "yungsang/coreos"

  number_of_instances = 3
  (1..number_of_instances).each do |instance_number|
    config.vm.define "host-#{instance_number}" do |host|
      host.vm.hostname = "host-#{instance_number}"
      # Hardcode IPs as 192.168.50.101, 192.168.50.102, etc. to make it easier to write
      # step-by-step directions in README.md
      host.vm.network "private_network", ip: "192.168.50.10#{instance_number}"

      # Use the local registry mirror, to speed up pulls
      host.vm.provision :shell do |sh|
        sh.inline = <<-EOT
          sudo echo 'DOCKER_OPTS="--registry-mirror http://192.168.33.201:5000 --insecure-registry 192.168.33.201:5000"' > /run/docker_opts.env
          sudo systemctl restart docker
        EOT
      end

      # To not run provisioners, do: vagrant up --no-provision
      provisioner = if instance_number == 1 # first
                      "provision/1.sh"
                    elsif instance_number == number_of_instances # last
                      "provision/3.sh"
                    else
                      "provision/2.sh"
                    end
      host.vm.provision "shell", path: provisioner
    end
  end
end
