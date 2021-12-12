Vagrant.configure("2") do |config|
  config.vm.provision "shell", path: "database.sh"
  config.vm.define "database" do |database|
    database.vm.box = "ubuntu/xenial64"
    database.vm.network "private_network",ip: "192.168.56.56"
      database.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
     end
  end
end
