class other {
	$packages = ["git-core", "curl", "vim"]

	package { $packages: ensure => present }
}