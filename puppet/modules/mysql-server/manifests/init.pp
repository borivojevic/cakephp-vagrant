class mysql-server {
	$password = "root"

	package { "mysql-server": ensure => installed }

	service { "mysql":
		ensure => running,
		require => Package["mysql-server"],
	}

	exec { "set-mysql-passwrod":
		unless => "mysqladmin -uroot -p$password status",
		command => "mysqladmin -uroot password $password",
		require => Service["mysql"],
	}
}