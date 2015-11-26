Vagrant.configure("2") do |config|
  config.vm.box = "yungsang/coreos"

  number_of_instances = 3
  (1..number_of_instances).each do |instance_number|
    config.vm.define "host-#{instance_number}" do |host|
      host.vm.hostname = "host-#{instance_number}"
      # Hardcode IPs as 192.168.50.101, 192.168.50.102, etc. to make it easier to write
      # step-by-step directions in README.md
      host.vm.network "private_network", ip: "192.168.50.10#{instance_number}"
    end
  end
end
