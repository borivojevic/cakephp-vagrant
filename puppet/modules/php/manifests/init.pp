class php {
	$packages = ["php5", "php5-cli", "php5-mysql", "php-pear", "php5-dev", "php5-gd", "php5-mcrypt"]

	package
    {
        $packages:
            ensure  => latest,
            require => [Exec['apt-get update'], Package['python-software-properties']]
    }

    exec
    {
        "sed -i 's|#|//|' /etc/php5/mods-available/mcrypt.ini":
            require => Package['php5'],
    }
}