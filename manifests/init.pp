# init.pp

class opendkim (
  $puppetmaster = false,
  $keydir       = '/etc/puppet/files/dkimkeys',
  $maildomains  = [],
 ) {


  if $puppetmaster {

    package { 'opendkim-tools':
      ensure => 'present',
    }
    class { "opendkim::key_generator":
      keydir      => $keydir,
      maildomains => $maildomains,
    }

  } else {
    package { 'opendkim':
      ensure => 'present',
    }
  }

}
