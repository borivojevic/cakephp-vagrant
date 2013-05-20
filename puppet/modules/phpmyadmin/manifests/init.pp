class phpmyadmin {

	$version = '4.0.0'
	$download_link = "http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/${version}/phpMyAdmin-${version}-all-languages.tar.gz"
	$installpath = "/usr/share/phpmyadmin/"

	# Download latest pma
	exec { "download_phpmyadmin":
		command => "/usr/bin/wget -o /dev/null -O /tmp/phpmyadmin.${version}.tar.gz ${download_link}",
		creates => "/tmp/phpmyadmin.${version}.tar.gz"
	} ->
	exec { 'unpack_phpmyadmin':
		command => "/bin/tar -xzvf /tmp/phpmyadmin.${version}.tar.gz",
		creates => "/tmp/phpMyAdmin-${version}-all-languages",
		cwd     => "/tmp",
		group   => root,
		user    => root,
		require => Exec['download_phpmyadmin']
  	} ->
  	file { $installpath:
		ensure => directory,
		recurse => true,
		group => 'www-data',
		owner => "www-data",
		mode => 644,
	} ->
	exec { 'Move to the install path':
		command => "/bin/mv /tmp/phpMyAdmin-${version}-all-languages ${installpath}",
		group   => root,
		user    => root,
		creates => "${installpath}/phpMyAdmin-${version}-all-languages"
	} ->
	file { "/vagrant/webroot/":
		ensure  => link,
		target  => "${installpath}/phpMyAdmin-${version}-all-languages",
	}
}