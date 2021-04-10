ENV['VAGRANT_NO_PARALLEL'] = 'yes'

  

Vagrant.configure(2) do |config|
  
  config.vm.provision "shell", path: "bootstrap.sh"
  

  # Kubernetes Master Node
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "centos/7"
    kmaster.vm.hostname = "master"
    
    kmaster.vm.network "private_network", ip: "172.16.1.100"
    kmaster.vm.network "forwarded_port", guest: 30080, host: 80
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "master"
      v.memory = 2048
      v.cpus = 2
      # Prevent VirtualBox from interfering with host audio stack
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
    kmaster.vm.provision "shell", path: "master.sh"
  end

  NodeCount = 1

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "worker#{i}" do |workernode|
      workernode.vm.box = "centos/7"
      workernode.vm.hostname = "worker#{i}"
      workernode.vm.network "private_network", ip: "172.16.1.10#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "worker#{i}"
        v.memory = 1024
        v.cpus = 1
        # Prevent VirtualBox from interfering with host audio stack
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
      workernode.vm.provision "shell", path: "workers.sh"
    end
  end

end