class php54 {
    apt::ppa { "ppa:ondrej/php5": }
    $php = ["php5", "libapache2-mod-php5"]
    package { $php: ensure => "latest", require => Exec['apt-get-update'] }

    exec { "mod-php":
        unless => "ls /etc/apache2/mods-enabled/php5*",
        command => "a2enmod php5",
        notify  => Service["apache2"],
    }
}