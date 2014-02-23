# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

exec
{
    'apt-get update':
        command => '/usr/bin/apt-get update',
        require => Exec['add php55 apt-repo']
}

# Create some synchronization between operations
class cakephpbox {
    class { "ubuntu": }
    class { "other": require => Exec['apt-get-update'], }
    class { "apache2": require => Exec['apt-get-update'], }
    class { "php55": require => Exec['apt-get-update'], }
    class { "php": require => Exec['apt-get-update'], }
    class { "php::pear": require => Exec['apt-get-update'], }
    class { "mysql-server": require => Exec['apt-get-update'], }
    class { "phpmyadmin": require => Exec['apt-get-update'], }
    class { "composer": require => Exec['apt-get-update'], }
}

# Tell Puppet to run the cakephpbox class at boot time:
class { "cakephpbox": }
