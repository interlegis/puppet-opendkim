#dkim::key_generator.pp

# DKIM Key generator for Puppet Masters

class opendkim::key_generator ( $maildomains = [],
                                $keydir      = '/etc/puppet/files/dkimkeys', 
                              ) {
  file { $keydir:
    ensure => directory,
    owner  => 'root',
    group  => 'puppet',
    mode   => '550',
  }

  opendkim::dkimkey { $maildomains:
    keydir => $keydir,
  }

}

