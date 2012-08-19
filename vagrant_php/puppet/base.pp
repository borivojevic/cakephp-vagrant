# Set the default path for all execution of commmands:
Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

class ubuntu {
    group { "puppet": ensure => "present"; } ->
    group { "vagrant": ensure => "present"; } ->
    user { "vagrant": ensure => "present"; } ->
    file { "/home/vagrant/bin":
        ensure  => "directory",
        owner   => "vagrant",
        group   => "vagrant",
        mode    => "755",
    }

    # update once
    exec {"apt-get-update":
        command => "apt-get update",
    }
}

class apache2 {
    package { "apache2": ensure => installed }

    $config = '/etc/apache2/sites-available/default'
    exec { "servername":
        subscribe => Package["apache2"],
        unless  => "grep '^ServerName' /etc/apache2/apache2.conf",
        command => "echo ServerName app >> /etc/apache2/apache2.conf",
        notify  => Service["apache2"],
    } ->
    exec { "mod-rewrite":
        unless => "ls /etc/apache2/mods-enabled/rewrite*",
        command => "a2enmod rewrite",
        notify  => Service["apache2"],
    } ->
    exec { "allow-override":
        unless => "sed -n '11 p' $config | grep 'AllowOverride All'",
        command => "sed -i '11 s/None/All/' $config",
        notify  => Service["apache2"],
    } ->
    user { "www-data":
        groups => ["vagrant"],
        notify  => Service["apache2"],
    } ->
    file { "/var/www/app":
        ensure => link,
        target => "/vagrant/src/app",
    } ->
    service { "apache2":
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        require => Package["apache2"],
    }
}

# Create some synchronization between operations
class cakephpbox {
    class { "ubuntu": }
	class { "apache2": require => Exec['apt-get-update'], }
	class { "php54": require => Exec['apt-get-update'], }
}

# Tell Puppet to run the cakephpbox class at boot time:
class { "cakephpbox": }