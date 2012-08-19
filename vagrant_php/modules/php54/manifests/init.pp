class php54 {
    file { "/etc/apt/sources.list":
        ensure => file,
        owner => root,
        group => root,
        source => "puppet:///modules/php54/sources.list",
    }
    exec { "update-key":
        command => "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C"
    }
    $php = ["php5", "php5-cli", "php5-mysql", "libapache2-mod-php5", "php-pear"]
    package { $php: ensure => "latest" }

    $include = '.:/usr/share/php:/vagrant/src/cakephp/lib/'
    $cliini = '/etc/php5/cli/php.ini'
    $apacheini = '/etc/php5/apache2/php.ini'
    exec { "cli-include-path":
        subscribe => Package["php5-cli"],
        unless => "grep -q ^include_path $cliini",
        command => "echo include_path = $include >> $cliini",
        notify  => Service["apache2"],
    } ->
    exec { "apache-include-path":
        unless => "grep -q ^include_path $apacheini",
        command => "echo include_path = $include >> $apacheini",
        notify  => Service["apache2"],
    } ->
    exec { "mod-php":
        unless => "ls /etc/apache2/mods-enabled/php5*",
        command => "a2enmod php5",
        notify  => Service["apache2"],
    } ->
    exec { "phpunit":
        creates => "/usr/bin/phpunit",
        command => "pear upgrade pear && \
                    pear channel-discover pear.phpunit.de && \
                    pear channel-discover components.ez.no && \
                    pear channel-discover pear.symfony-project.com && \
                    pear install --alldeps phpunit/PHPUnit",
        require => Package["php-pear"],
    }
}