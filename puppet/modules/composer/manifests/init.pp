class composer {

    exec { "download_composer":
        command => "curl -sS https://getcomposer.org/installer | php",
        cwd => "/home/vagrant",
        creates => "/home/vagrant/composer.phar",
        require => [ Package["php5-cli"] ]
    }

    file { "/home/vagrant/bin/composer.phar":
        ensure => present,
        source => "/home/vagrant/composer.phar",
        require => [ Exec['download_composer'], File["/home/vagrant/bin"], ],
        group => 'vagrant',
        mode => '0755',
    }
}