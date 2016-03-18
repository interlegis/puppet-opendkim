# init.pp

class opendkim (
  $puppetmaster = false,
  $keydir       = '/etc/puppet/files/dkimkeys',
  $maildomains  = [],
  $trustedhosts = [],
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
    package { "opendkim": ensure => "present" }
  
    service { opendkim:
      ensure => running,
      enable => true,
      hasrestart => true,
      hasstatus => false,
      notify => Service["postfix"],
      require => File["/etc/mailname"],
    }

    file { "/etc/mailname":
      content => inline_template('<%= fqdn %>')
    }

    file { "/etc/opendkim.conf":
      ensure => "present",
      content => template("opendkim/opendkim.conf.erb"),
      notify => Service["opendkim"]
    }

    file { "/etc/default/opendkim":
      ensure => "present",
      content => template("opendkim/default-opendkim.erb"),
      notify => Service["opendkim"]
    }

    file { "/etc/opendkim/TrustedHosts":
      ensure => "present",
      content => template("opendkim/opendkim-TrustedHosts.erb"),
      notify => Service["opendkim"]
    }

    file { ["/etc/opendkim","/etc/opendkim/keys"]:
      ensure => directory,
      require => Package["opendkim"],
    }

    file { "/etc/opendkim/KeyTable":
      content => template('opendkim/KeyTable.erb'),
      require => File["/etc/opendkim"],
      notify => Service["opendkim"],
    }

    file { "/etc/opendkim/SigningTable":
      content => template('opendkim/SigningTable.erb'),
      require => File["/etc/opendkim"],
      notify => Service["opendkim"],
    }


  }

}
