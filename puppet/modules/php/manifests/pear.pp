class php::pear {
	include php

	# upgrade PEAR
	exec { "pear upgrade":
		require => Package["php-pear"]
	}

	# install PHPUnit
	exec { "pear config-set auto_discover 1":
		require => Exec["pear upgrade"]
	}

	# create pear temp directory for channel-add
	file { "/tmp/pear/temp":
		require => Exec["pear config-set auto_discover 1"],
		ensure => "directory",
		owner => "root",
		group => "root",
		mode => 777
	}

	# discover channels
	exec { "pear channel-discover pear.phpunit.de; true":
		require => [File["/tmp/pear/temp"], Exec["pear config-set auto_discover 1"]]
	}

	exec { "pear channel-discover pear.cakephp.org; true":
		require => [File["/tmp/pear/temp"], Exec["pear config-set auto_discover 1"]]
	}

	# clear cache before install phpunit
	exec { "pear clear-cache":
		require => [Exec["pear channel-discover pear.phpunit.de; true"], Exec["pear channel-discover pear.cakephp.org; true"]]
	}

	# install phpunit
	exec { "pear install phpunit/File_Iterator":
		require => Exec["pear clear-cache"]
	}
	exec { "pear install phpunit/Text_Template":
		require => Exec["pear clear-cache"]
	}
	exec { "pear install --force --alldeps pear.phpunit.de/PHPUnit":
		require => Exec["pear clear-cache"]
	}

	# Install PHP COde Sniffer
	exec { "pear install PHP_CodeSniffer":
		require => Exec["pear clear-cache"]
	}

	# install CakePHP coding standard rules for code sniffer
	exec { "pear install cakephp/CakePHP_CodeSniffer":
		require => Exec["pear clear-cache"]
	}
}