Setup Vagrant Instance
=======================

Requirements:
---------------
- Download and install [Vagrant][]
- Vagrant depends on Oracle's [VirtualBox][] to create all of its virtual environments.

Installation:
---------------
- Download and install required software
- `git clone git://github.com/borivojevic/vagrant-setup.git`
- Place application source code into webroot folder
- Add `127.0.0.1 dev.mirkoborivojevic.localhost` to hosts file
- Run terminal and execute `vagrant up`
- Run web browser and go to `dev.mirkoborivojevic.localhost:8888`
- To turn off virtual machine execute `vagrant down`
- To clean up execute `vagrant destroy`

Packages installed
-------------------
- apache2
- php5
- php5-cli
- php5-mysql
- php5-dev
- php-pear
 - PHPUnit
 - PHP_CodeSniffer
 - CakePHP_CodeSniffer
- mysql-server


Nice to have (not installed yet)
--------------------------------
- git
- phpmyadmin
- cakephp
- xdebug
- composer

[Vagrant]: http://downloads.vagrantup.com/tags/v1.0.3
[VirtualBox]: http://www.virtualbox.org/wiki/Downloads

Troubleshooting
---------------

Vagrant sometimes hangs on "Waiting for VM to boot. This can take a few minutes". To fix this enable GUI mode in Vagrant configuration, login in VirtualBox and run "sudo dhclient".