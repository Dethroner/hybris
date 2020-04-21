IMAGE_NAME = "generic/debian10"
LAN_NET = "10.50.10."

servers = [
  {
	:hostname => "dev",
	:cpu => "2",
	:ram => "2048",
	:ip => LAN_NET + "10",
	:tag => "prod",
  },
  {
    :hostname => "prod",
	:ip => LAN_NET + "11",
	:tag => "prod",
  }
]

Vagrant.configure("2") do |config|
  config.vm.box = IMAGE_NAME
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
	servers.each do |machine|
		config.vm.define machine[:hostname] do |master|
			master.vm.hostname = machine[:hostname]
			master.vm.provider "virtualbox" do |vb|
				vb.name = machine[:hostname]
				vb.cpus = 1
				vb.memory = "1024"
				if (!machine[:cpu].nil?)
					unless File.exist?(machine[:cpu])
					vb.customize ["modifyvm", :id, "--cpus", machine[:cpu]]
					end
				end
				if (!machine[:ram].nil?)
					unless File.exist?(machine[:ram])
					vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
					end
				end
			end
			master.vm.network "private_network", ip: machine[:ip]
			master.vm.network "forwarded_port", guest: 9001, host: 9001, host_ip: machine[:ip]
			master.vm.network "forwarded_port", guest: 9002, host: 9002, host_ip: machine[:ip]
			master.vm.provision :shell, path: "./files/user-slave.sh", args: "appuser"
			master.vm.provision :shell, path: "./files/vm-route.sh", privileged: true
			master.vm.provision :shell, path: "./files/filebeat.sh", args: machine[:tag], privileged: true
			master.vm.provision :shell, path: "./files/bootstrap.sh", privileged: true
			master.vm.provision :shell, privileged: true, inline: <<-SHELL
				/opt/hybrisstart.sh &> /tmp/start.out&
			SHELL
		end
	end
end
