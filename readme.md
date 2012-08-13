Setup Vagrant Instance
=======================
- Download and install [Vagrant][]

- Create project directory and setup required files

```sh
$ mkdir vagrant_php
$ cd vagrant_php
$ vagrant init
```

- Download a base box wich has a bare bones installation of Ubuntu Lucid (10.04) 32-bit

```sh
$ vagrant box add base http://files.vagrantup.com/lucid32.box
```

- Configure the project to use the box

```ruby
Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
end
```

- Configure port forwarding

```ruby
Vagrant::Config.run do |config|
  # Forward guest port 80 to host port 4567
  config.vm.forward_port 80, 4567
end
```

- Test the setup

```sh
$ vagrant up
...
$ vagrant down
...
```
 
 [Vagrant]: http://downloads.vagrantup.com/tags/v1.0.3