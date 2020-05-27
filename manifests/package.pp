# @summary Installs milter-greylist package
#
class milter_greylist::package {
  package { 'milter-greylist':
    ensure => present,
  }
}
