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