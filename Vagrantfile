# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  config.vm.network :private_network, ip: '33.33.33.66'

  config.ssh.forward_agent = true


  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.memory = 1024
  end

  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = 'provision/Berksfile'

  config.vm.provision :shell, path: 'provision/basic_packages.sh'
  config.vm.provision :shell, path: 'provision/shared/vim.sh'
  config.vm.provision :shell, path: 'provision/shared/git.sh'
  config.vm.provision :shell, path: 'provision/lang.sh' #hack to fix postgres lang
  config.vm.provision :shell, path: 'provision/ruby2.sh'
  config.vm.provision :shell, path: 'provision/shared/zsh.sh', privileged: false
  config.vm.provision :shell, inline: 'mkdir -p /var/chef/cache' #hack to fix postgres chef recipe bug
  config.vm.provision :shell, inline: "echo -e '#{File.read("#{Dir.home}/.gitconfig")}' > '/home/vagrant/.gitconfig'"

  config.vm.provision :chef_solo do |chef|
    ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
    chef.add_recipe 'postgresql::apt_pgdg_postgresql'
    chef.add_recipe 'postgresql::server'

    chef.log_level = :debug
    chef.json = {
        postgresql: {
            :version => '9.3',
            :enable_pgdg_apt => true,
            :dir => '/etc/postgresql/9.3/main',
            :server => {
                packages: %w(postgresql-9.3 postgresql-server-dev-9.3)
            },
            contrib: {
                packages: %w(postgresql-contrib-9.2)
            },
            :config => {
                :ssl => false,
                :listen_addresses => '*',
            },
            :pg_hba => [
                {type: 'local', db: 'all', user: 'all', addr: nil, method: 'trust'},
                {type: 'host', db: 'all', user: 'all', addr: '127.0.0.1/32', method: 'trust'},
                {type: 'host', db: 'all', user: 'all', addr: '33.33.33.0/24', method: 'trust'},
                {type: 'host', db: 'all', user: 'all', addr: '::1/128', method: 'trust'}
            ],
            password: {
                postgres: 'password'
            }
        },
        run_list: %w(recipe[postgresql::server])
    }
  end

  config.vm.provision :shell, path: 'provision/shared/bundle.sh'
  config.vm.provision :shell, inline: "echo -e '#{File.read("#{Dir.home}/.gitconfig")}' > '/home/vagrant/.gitconfig'"
  config.vm.provision :shell, path: 'provision/postgis.sh', privileged: false
  config.vm.provision :shell, path: 'provision/postgres_encoding_fix.sh', privileged: false
  config.vm.provision :shell, path: 'provision/rails.sh', privileged: false
end
