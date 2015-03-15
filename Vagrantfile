# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  rbenv_setup = lambda do |ruby_version|
    <<-RBENV
      sudo -u vagrant git clone https://github.com/sstephenson/rbenv.git ~vagrant/.rbenv
      sudo -u vagrant echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~vagrant/.bash_profile
      sudo -u vagrant echo 'eval "$(rbenv init -)"' >> ~vagrant/.bash_profile
      sudo -u vagrant git clone https://github.com/sstephenson/ruby-build.git ~vagrant/.rbenv/plugins/ruby-build
      sudo -u vagrant -i rbenv install #{ruby_version}
      sudo -u vagrant -i rbenv global #{ruby_version}
      sudo -u vagrant -i gem install bundler
    RBENV
  end

  config.vm.define "kernel-2.6-ruby-2.0" do |conf|
    ruby_version = "2.0.0-p451"

    conf.vm.box = "nrel/CentOS-6.5-x86_64"
    conf.vm.box_url = "https://vagrantcloud.com/nrel/boxes/CentOS-6.5-x86_64/versions/1.2.0/providers/virtualbox.box"

    conf.vm.provision "shell", inline: <<-PROVISIONER
      yum update -y
      wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
      wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
      rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
      yum install git libffi-devel openssl-devel readline-devel -y
      yum groupinstall "Development Tools" -y
      #{rbenv_setup[ruby_version]}
    PROVISIONER
  end

  config.vm.define "kernel-3.10-ruby-2.2" do |conf|
    ruby_version = "2.2.0"

    conf.vm.box = "chef/centos-7.0"
    conf.vm.box_url = "https://atlas.hashicorp.com/chef/boxes/centos-7.0/versions/1.0.0/providers/virtualbox.box"

    conf.vm.provision "shell", inline: <<-PROVISIONER
      yum update -y
      wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
      wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
      rpm -Uvh remi-release-7*.rpm epel-release-7*.rpm
      yum groupinstall "Development Tools" -y
      yum install git libffi-devel openssl-devel readline-devel -y
      #{rbenv_setup[ruby_version]}
    PROVISIONER
  end
end
