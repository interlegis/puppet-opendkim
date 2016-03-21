# opendkim::dkimkey.pp

define opendkim::dkimkey {

  file { "/etc/opendkim/keys/$name":
    ensure => directory,
    require => File["/etc/opendkim/keys"],
  }
  file { "/etc/opendkim/keys/$name/default.private":
    ensure => "present",
    owner => "opendkim", group => "opendkim", mode => 440,
    source => "puppet:///files/dkimkeys/$name/default.private",
    require => File["/etc/opendkim/keys/$name"],
    notify => Service["opendkim"],
  }
  file { "/etc/opendkim/keys/$name/default.txt":
    ensure => "present",
    owner => "root", group => "root", mode => 440,
    source => "puppet:///files/dkimkeys/$name/default.txt",
    require => File["/etc/opendkim/keys/$name"],
    notify => Service["opendkim"],
  }


}
