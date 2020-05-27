# @summary Ensure service is running
#
class milter_greylist::service {
  service { 'milter-greylist':
      ensure => running,
      enable => true,
    }
}
