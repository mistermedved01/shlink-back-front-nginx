ENV['VAGRANT_SERVER_URL'] = 'http://vagrant.elab.pro'

Vagrant.configure("2") do |config|
  # VM1: shlink_db
  config.vm.define "shlink_db" do |shlink_db|
    shlink_db.vm.box = "bento/ubuntu-24.04"
    shlink_db.vm.network "private_network", ip: "192.168.1.102"
    shlink_db.vm.provision "shell", path: "scripts/shlink_db_install.sh"
    shlink_db.vm.provider "virtualbox" do |vb|
      vb.name = "shlink_db"
      vb.memory = "2000"
      vb.cpus = 2
    end
  end

  # VM2: shlink_back_front
  config.vm.define "shlink_back_front" do |shlink_back_front|
    shlink_back_front.vm.box = "bento/ubuntu-24.04"
    shlink_back_front.vm.network "private_network", ip: "192.168.1.103"
    shlink_back_front.vm.provision "shell", path: "scripts/shlink_back_install.sh"
    shlink_back_front.vm.provision "shell", path: "scripts/shlink_front_install.sh"
    shlink_back_front.vm.provider "virtualbox" do |vb|
      vb.name = "shlink_back_front"
      vb.memory = "2000"
      vb.cpus = 2
  end
end

  # VM3: nginx_reverse_proxy
  config.vm.define "shlink_nginx_reverse_proxy" do |nginx_reverse_proxy|
    nginx_reverse_proxy.vm.box = "bento/ubuntu-24.04"
    nginx_reverse_proxy.vm.network "private_network", ip: "192.168.1.101"
    nginx_reverse_proxy.vm.provision "shell", path: "scripts/shlink_nginx_reverse_proxy.sh"
    nginx_reverse_proxy.vm.provider "virtualbox" do |vb|
      vb.name = "nginx_reverse_proxy"
      vb.memory = "2000"
      vb.cpus = 2
   end
  end
end