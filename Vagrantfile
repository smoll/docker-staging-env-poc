Vagrant.configure("2") do |config|
  config.vm.box = "yungsang/coreos"
  config.vm.network "private_network", type: "dhcp"

  number_of_instances = 3
  (1..number_of_instances).each do |instance_number|
    config.vm.define "host-#{instance_number}" do |host|
      host.vm.hostname = "host-#{instance_number}"
    end
  end
end
