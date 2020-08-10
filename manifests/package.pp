# @summary Installs milter-greylist package
#
class milter_greylist::package (
  String $package_ensure,
){
  package { 'milter-greylist':
    ensure => $package_ensure,
  }
}
