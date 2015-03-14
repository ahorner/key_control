# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
DEFAULT_RUBY = "2.2.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/centos-6.5"
  config.vm.box_url = "https://vagrantcloud.com/chef/centos-6.5/version/1/provider/virtualbox.box"

  config.vm.provision "shell", inline: <<-PROVISIONER
    yum update -y
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
    yum install git libffi-devel openssl-devel readline-devel -y
    yum groupinstall "Development Tools" -y
    sudo -u vagrant git clone https://github.com/sstephenson/rbenv.git ~vagrant/.rbenv
    sudo -u vagrant echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~vagrant/.bash_profile
    sudo -u vagrant echo 'eval "$(rbenv init -)"' >> ~vagrant/.bash_profile
    sudo -u vagrant git clone https://github.com/sstephenson/ruby-build.git ~vagrant/.rbenv/plugins/ruby-build
    sudo -u vagrant -i rbenv install #{DEFAULT_RUBY}
    sudo -u vagrant -i rbenv global #{DEFAULT_RUBY}
    sudo -u vagrant -i gem install bundler
  PROVISIONER
end
