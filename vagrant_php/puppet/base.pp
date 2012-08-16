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
        creates => "/updated",
        command => "apt-get update && touch /updated",
    }
}

# Create some synchronization between operations
class cakephpbox {
    class { "ubuntu": }
}

# Tell Puppet to run the cakephpbox class at boot time:
class { "cakephpbox": }