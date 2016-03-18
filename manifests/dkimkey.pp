# opendkim::dkimkey.pp

define opendkim::dkimkey ( 
  $keydir = '/etc/puppet/files/dkimkeys/',
) {

  file { "$keydir/$name":
    ensure => directory,
    require => File[$keydir],
    notify => Exec["opendkim genkey $name"],
  }

  exec { "opendkim genkey $name":
    cwd => "$keydir/$name",
    command => "opendkim-genkey -r -d $name",
    creates => "$keydir/$name/default.private",
    timeout => 30,
    refreshonly => true,
  }

  file { ["$keydir/$name/default.private","$keydir/$name/default.txt"]:
    owner => 'puppet',
    group => 'root',
    mode  => '440',
    require => Exec["opendkim genkey $name"],
  }
}
