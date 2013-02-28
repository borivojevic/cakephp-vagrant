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

class php {
    $php = ["php5-cli", "php5-mysql", "libapache2-mod-php5", "php-pear"]
    package { $php: ensure => "installed" }

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

class mysql-server {
    $password = "root"
    package { "mysql-client": ensure => installed }
    package { "mysql-server": ensure => installed }

    exec { "Set MySQL server root password":
        subscribe => [ Package["mysql-server"], Package["mysql-client"] ],
        refreshonly => true,
        unless => "mysqladmin -uroot -p$password status",
        path => "/bin:/usr/bin",
        command => "mysqladmin -uroot password $password",
    }
}

# Create some synchronization between operations
class cakephpbox {
    class { "ubuntu": }
    class { "apache2": require => Exec['apt-get-update'], }
    class { "php": require => Exec['apt-get-update'], }
    class { "mysql-server": require => Exec['apt-get-update'], }
}

# Tell Puppet to run the cakephpbox class at boot time:
class { "cakephpbox": }
