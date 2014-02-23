class apache2 {
	package { "apache2": ensure => installed }

	# ensures that mode_rewrite is loaded and modifies the default configuration file
	file { "/etc/apache2/mods-enabled/rewrite.load":
		ensure => link,
		target => "/etc/apache2/mods-available/rewrite.load",
		require => Package["apache2"]
	}

	file { "/etc/apache2/sites-available/000-default.conf":
		ensure => present,
		source => "/vagrant/puppet/templates/vhost",
		require => Package["apache2"]
	}

	# starts the apache2 service once the packages installed, and monitors changes to its configuration files and reloads if nesessary
	service { "apache2":
		ensure => running,
		require => Package["apache2"],
		subscribe => [
			File["/etc/apache2/mods-enabled/rewrite.load"],
			File["/etc/apache2/sites-available/000-default.conf"]
		],
	}
}