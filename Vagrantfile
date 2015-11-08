# Vagrantfile template
# you need to replace all 5 with digit 1-9
# hostnames are hard coded in following locations:
# cerebro|files|post-receive
# manos::default
#
# do NOT just "vagrant up" this whole cluster. not recommended.
# currently, need to do startup.sh and then vagrant up the machines one by on in this order
#  cerebro, brazos, espina, hombros, manos, cara

#Berksfile tweak needed per https://github.com/berkshelf/vagrant-berkshelf/issues/237  **/.git

# dependencies:
  # manos => cerebro
  # manos => hombros
  # hombros => brazos
  # hombros => espina
  # hombros => cerebro
  # cara => espina

Vagrant.configure(2) do |config|
  if ARGV[1]=='base'
    config.vm.box = "opscode/temp"
  else
    config.vm.box_url = "/var/vagrant/boxes/opscode-ubuntu-14.04a.box" # if this errors, you need startup.sh run
    config.vm.box = "opscode-ubuntu-14.04a"  # this box will not be on your machine to start
  end
  config.berkshelf.enabled = true

  # how to boost capacity
      #config.vm.provider :virtualbox do |virtualbox|
      #virtualbox.customize ["modifyvm", :id, "--memory", "1024"]   # e.g. for Chef Server
      #virtualbox.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    #end

###############################################################################
###################################    base   #################################
###############################################################################

# Called by startup.sh. You should NOT "vagrant up base" directly, as it also needs
# to be repackaged
#
# purpose of doing this is to save time
# eliminates repeated chef, virtualbox utils & java downloads, also apt-get updates & installs tree & curl
# also configures ssh & hosts

  config.vm.define "base" do | base |
    base.vm.host_name              ="base.calavera.biz"
    base.vm.network                 "private_network", ip: "10.0.0.99"
    base.vm.network                 "forwarded_port", guest: 22, host: 2229, auto_correct: true
    base.vm.network                 "forwarded_port", guest: 80, host: 8029
    base.vm.network                 "forwarded_port", guest: 8080, host: 8129

    base.vm.synced_folder           ".",         "/home/base"
    base.vm.synced_folder           "./shared", "/mnt/shared"

    base.vm.provision :chef_zero do |chef|
      chef.cookbooks_path           = ["./cookbooks/"]
      chef.add_recipe               "base::default"  #configures ssh and hostnames. good to do every so often.
    end
  end

###############################################################################
###################################    cerebro5   ##############################
###############################################################################

  config.vm.define "cerebro5" do | cerebro5 |
    cerebro5.vm.host_name           ="cerebro5.calavera.biz"
    cerebro5.vm.network             "private_network", ip: "10.5.0.10"
    cerebro5.vm.network            "forwarded_port", guest: 22, host: 2510, auto_correct: true
    cerebro5.vm.network            "forwarded_port", guest: 80, host: 8510, auto_correct: true
    cerebro5.vm.network             "forwarded_port", guest: 8080, host: 9510, auto_correct: true

    cerebro5.ssh.forward_agent       =true

    cerebro5.vm.synced_folder      ".",         "/home/cerebro5"
    cerebro5.vm.synced_folder      "./shared", "/mnt/shared"

    #cerebro5.vm.provision       :shell, path: "./shell/cerebro5.sh"

    cerebro5.vm.provision :chef_zero do |chef|
      chef.cookbooks_path         = ["./cookbooks/"]
      chef.add_recipe             "shared::default"  # need to split hosts from ssh, or idemp hosts
      chef.add_recipe             "git::default"
      chef.add_recipe             "cerebro::default"
    end
  end

# test: vagrant ssh cerebro5, git -v

###############################################################################
###################################    brazos5     ##############################
###############################################################################

  config.vm.define "brazos5" do | brazos5 |
    brazos5.vm.host_name            ="brazos5.calavera.biz"
    brazos5.vm.network               "private_network", ip: "10.5.0.11"
    brazos5.vm.network               "forwarded_port", guest: 22, host: 2511, auto_correct: true
    brazos5.vm.network               "forwarded_port", guest: 80, host: 8511, auto_correct: true
    brazos5.vm.network              "forwarded_port", guest: 8080, host: 9511, auto_correct: true

    brazos5.ssh.forward_agent       =true

    brazos5.vm.synced_folder        ".",         "/home/brazos5"
    brazos5.vm.synced_folder        "./shared", "/mnt/shared"

    brazos5.vm.provision :chef_zero do |chef|
      chef.cookbooks_path         = ["./cookbooks/"]
      chef.add_recipe             "git::default"
      chef.add_recipe             "localAnt::default"
      chef.add_recipe             "shared::_junit"
      chef.add_recipe             "java7::default"
      chef.add_recipe             "tomcat::default"
      chef.add_recipe             "brazos::default"
    end
  end

###############################################################################
###################################    espina5     ##############################
###############################################################################

  config.vm.define "espina5" do | espina5 |
    espina5.vm.host_name            ="espina5.calavera.biz"
    espina5.vm.network               "private_network", ip: "10.5.0.12"
    espina5.vm.network               "forwarded_port", guest: 22, host: 2512, auto_correct: true
    espina5.vm.network               "forwarded_port", guest: 80, host: 8512, auto_correct: true
    espina5.vm.network              "forwarded_port", guest: 8080, host: 9512, auto_correct: true
    espina5.vm.network              "forwarded_port", guest: 8081, host: 7512, auto_correct: true

    espina5.ssh.forward_agent        =true

    espina5.vm.synced_folder        ".",         "/home/espina5"
    espina5.vm.synced_folder        "./shared", "/mnt/shared"
    #espina5.vm.provision       :shell, path: "./shell/espina5.sh"

    espina5.vm.provision :chef_zero do |chef|
      chef.cookbooks_path         = ["./cookbooks/"]
      chef.add_recipe             "java7::default"
      #chef.add_recipe            "java8::default" reverting to ARtifactory 3.51
      chef.add_recipe             "espina::default"
    end
  end

  # test: x-windows http://10.5.0.12:8081/artifactory, admin/password
  # curl not working
  # artifactory / jenkins config is stored in cookbooks/hombros/files/org.jfrog.hudson.ArtifactoryBuilder.xml
  # select "target repository" in hijoInit setup (defaults to ext-release-local) - this probably will show up in xml export

###############################################################################
###################################    hombros5     ##############################
###############################################################################

  config.vm.define "hombros5" do | hombros5 |
    hombros5.vm.host_name          ="hombros5.calavera.biz"
    hombros5.vm.network             "private_network", ip: "10.5.0.13"
    hombros5.vm.network            "forwarded_port", guest: 22, host: 2513, auto_correct: true
    hombros5.vm.network            "forwarded_port", guest: 80, host: 8513, auto_correct: true
    hombros5.vm.network            "forwarded_port", guest: 8080, host: 9513, auto_correct: true

    hombros5.ssh.forward_agent      =true

    hombros5.vm.synced_folder        ".",         "/home/hombros5"
    hombros5.vm.synced_folder        "./shared", "/mnt/shared"

    #hombros5.vm.provision          :shell, path: "./shell/hombros5.sh"

    hombros5.vm.provision :chef_zero do |chef|
      chef.cookbooks_path           = ["./cookbooks/"]
      chef.add_recipe               "git::default"
      chef.add_recipe               "jenkins::master"
      chef.add_recipe               "hombros::default"
    end

  end

  # Jenkins should appear at http://10.5.0.13:8080

###############################################################################
###################################    manos5     ##############################
###############################################################################

  config.vm.define "manos5" do | manos5 |
    manos5.vm.host_name            ="manos5.calavera.biz"
    manos5.vm.network              "private_network", ip: "10.5.0.14"
    manos5.vm.network              "forwarded_port", guest: 22, host: 2514, auto_correct: true
    manos5.vm.network              "forwarded_port", guest: 80, host: 8514, auto_correct: true
    manos5.vm.network              "forwarded_port", guest: 8080, host: 9514, auto_correct: true

    manos5.ssh.forward_agent        =true

    manos5.vm.synced_folder        ".",         "/home/manos5"
    manos5.vm.synced_folder        "./shared", "/mnt/shared"
    #manos5.vm.provision         :shell, path: "./shell/manos5.sh"

    manos5.vm.provision :chef_zero do |chef|
      chef.cookbooks_path         = ["./cookbooks/"]
      chef.add_recipe             "git::default"
      chef.add_recipe             "localAnt::default"
      chef.add_recipe             "java7::default"   #   this is redundant. we already installed this in base and tomcat also installs Java. but won't work w/o it.
      chef.add_recipe             "tomcat::default"
      chef.add_recipe             "shared::_junit"
      chef.add_recipe             "manos::default"
    end
  end

  # test: http://10.5.0.14:8080/MainServlet
  # if cerebro is configured:
  # git add .
  # git commit -m "some message"
  # git push origin master


###############################################################################
###################################    cara5     ##############################
###############################################################################

  config.vm.define "cara5" do | cara5 |
    cara5.vm.host_name              ="cara5.calavera.biz"
    cara5.vm.network                 "private_network", ip: "10.5.0.15"
    cara5.vm.network                 "forwarded_port", guest: 22, host: 2515, auto_correct: true
    cara5.vm.network                 "forwarded_port", guest: 80, host: 8515, auto_correct: true
    cara5.vm.network                "forwarded_port", guest: 8080, host: 9515, auto_correct: true

    cara5.ssh.forward_agent        =true

    cara5.vm.synced_folder          ".",         "/home/cara5"
    cara5.vm.synced_folder          "./shared", "/mnt/shared"
    #cara5.vm.provision       :shell, path: "./shell/cara5.sh"]

    cara5.vm.provision :chef_zero do |chef|
      chef.cookbooks_path         = ["./cookbooks/"]
      chef.add_recipe             "java7::default"
      chef.add_recipe             "tomcat::default"
      chef.add_recipe             "cara::default"
    end
  end

    # test: http://10.5.0.14:8080/MainServlet

###############################################################################
###################################    nervios5     ##############################
###############################################################################
# monitoring

  config.vm.define "nervios5" do | nervios5 |
    nervios5.vm.host_name              ="nervios5.calavera.biz"
    nervios5.vm.network                 "private_network", ip: "10.5.0.16"
    nervios5.vm.network                 "forwarded_port", guest: 22, host: 2516, auto_correct: true
    nervios5.vm.network                 "forwarded_port", guest: 80, host: 8516, auto_correct: true
    nervios5.vm.network                "forwarded_port", guest: 8080, host: 9516, auto_correct: true

    nervios5.ssh.forward_agent        =true

      nervios5.vm.synced_folder         ".", "/home/nervios5"
      nervios5.vm.synced_folder         "./shared", "/mnt/shared"
    #nervios5.vm.provision       :shell, path: "./shell/nervios5.sh"

    nervios5.vm.provision :chef_zero do |chef|
      chef.cookbooks_path =       ["./cookbooks/"]
      #chef.add_recipe             "nervios::default"
    end
  end

###############################################################################
###################################    test     ##############################
###############################################################################
# a test machine to try out new things
# not part of the pipeline

  config.vm.define "test" do | test |
    test.vm.host_name              ="test.calavera.biz"
    test.vm.network                 "private_network", ip: "192.168.33.99"
    test.vm.network                 "forwarded_port", guest: 22, host: 2299, auto_correct: true
    test.vm.network                 "forwarded_port", guest: 80, host: 8099, auto_correct: true
    test.vm.network                "forwarded_port", guest: 8080, host: 8199, auto_correct: true

    test.ssh.forward_agent        =true

      test.vm.synced_folder         ".", "/home/test"
      test.vm.synced_folder         "./shared", "/mnt/shared"
    #test.vm.provision       :shell, path: "./shell/test.sh"

    test.vm.provision :chef_zero do |chef|
      chef.cookbooks_path =       ["./cookbooks/"]
      chef.add_recipe             "test::default"
    end
  end
###############################################################################

end
