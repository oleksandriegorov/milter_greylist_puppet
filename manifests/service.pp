# @summary Ensure service is running
#
class milter_greylist::service (
  String $service_ensure,
  Boolean $service_enable,
){
  service { 'milter-greylist':
      ensure => $service_ensure,
      enable => $service_enable,
    }
}
