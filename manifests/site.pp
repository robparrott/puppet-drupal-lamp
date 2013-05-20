# Basic LAMP stack box, expecting 2GB ram and not HUGE db requirements

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

#include git
include drush


######################################
## WEBSERVER
######################################
class {'apache': }
#class {'apache::mod::php': }
#a2mod { "Enable rewrite mod":
#  name    => "rewrite",
#  ensure  => "present"
#}
package {
  'php-gd':
    ensure => 'present';
  'php-pecl-apc':
    ensure => 'present';
  'php-mysql':
    ensure => 'present';
#  'php5-curl':
#    ensure => 'present';
}

## Standard /var/www default site
apache::vhost { $ipaddress:
  priority        => '1',
  port            => 80,
  docroot         => '/var/www',
  serveraliases   => ['127.0.0.1'],
  options         => 'FollowSymLinks',
  override        => ['all']
}

###################################### 
## Memcache
###################################### 

class { 'memcached': }

###################################### 
## Varnish
###################################### 
class { "varnish_rhel":
    varnish_data_directory => "/var/lib/varnish",
    varnish_storage_size   => "5G",
    varnish_listen_port    => 80
}

#varnish_rhel::vcl { '/etc/varnish/default.vcl':
#  vcl_content => template('files/etc/varnish/default.vcl.erb')
#}

#varnish_rhel::vcl { '/etc/varnish/backend.vcl':
#  vcl_content => template('files/etc/varnish/backend.vcl.erb')
#}


######################################
## DB
######################################
include mysql::server
class { 'mysql': }

## Basic database for Drupal to use
mysql::db { 'drupal':
  user     => 'drupal',
  password => 'ChangeMelikeRIGHTNOW',
  host     => 'localhost',
  grant    => ['all'],
}

