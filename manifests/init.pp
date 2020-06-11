# @summary Main class for milter-greylist module
#
# milter_greylist
# Main class for installation, configuration and enabling milter-greylist as a service
# milter-greylist itself is open source : http://hcpnet.free.fr/milter-greylist and helps a lot in dealing with spam
#
# @example Just including milter_greylist runs milter-greylist with default settings to greylist everyone except @mynetworks
#  include milter_greylist
# @example To add more IP subnets into mynetworks whitelist
#  include milter_greylist
#  class milter_greylist {
#    mynetworks => '10.0.0.0/8 192.168.0.0/22 127.0.0.1/8',
#  }
#
# @example It is advisable to set certain whitelisted IP addresses or countries to avoid getting into initial delay trouble
#  include milter_greylist
#  class milter_greylist {
#    whlcountries => ['CA'],
#      whlips => ['8.8.8.8', '8.8.4.4'],
#  }
#
# @example By default milter-greylist is configured to listen to inet socket, if you have reasons to use unix socket instead try this
#  include milter_greylist
#  class milter_greylist {
#    socket => '/var/run/milter-greylist/milter-greylist.sock',
#  }
#
# @param geoipcountryfile
#  Specifies the location of GeoIP database
# @param socketpath
#  Specifies the socket used to communicate with MTA
# @param mxpeers
#  Provides a list for synchronization of the greylist among multiple MX
# @param whlcountries
#  Provides a list of country codes you wish to exclude from a greylist
# @param whlips
#  Provides a list of IP addresses you wish to exclude from a greylist
# @param mynetworks
#  Your own network, which should not suffer greylisting. It is a string.
# @param greylistdelay
#  Sets how much time milter-greylist(8) will want the client to wait between the first attempt and the time the message is accepted
# @param autowhiteperiod
#  Sets the auto-whitelisting duration
# @param subnetmatchv4
#  Subnet matching feature
# @param spfwhitelist
#  Whitelist clients if they are SPF-compliant
# @param user
# Run milter-greylist(8) as a non root user
class milter_greylist (
  String $geoipcountryfile    = '/usr/local/share/GeoIP/GeoIP.dat',
  String $socketpath          = 'inet:3333@127.0.0.1',
  Array[String] $mxpeers      = [],
  Array[String] $whlcountries = ['US','CA'],
  Array[String] $whlips       = [],
  Array[String] $greyips      = [],
  Array[String] $greyasns     = [],
  String $mynetworks          = '127.0.0.1/8 10.0.0.0/8',
  String $greylistdelay       = '1h',
  String $autowhiteperiod     = '3d',
  String $subnetmatchv4       = '/24',
  Boolean $spfwhitelist       = false,
  String $user = 'grmilter',
) {
  include 'milter_greylist::package'
  include 'milter_greylist::service'
  class { 'milter_greylist::config':
    geoipcountryfile => $geoipcountryfile,
    socketpath       => $socketpath,
    mxpeers          => $mxpeers,
    whlcountries     => $whlcountries,
    whlips           => $whlips,
    greyips          => $greyips,
    greyasns         => $greyasns,
    mynetworks       => $mynetworks,
    greylistdelay    => $greylistdelay,
    autowhiteperiod  => $autowhiteperiod,
    subnetmatchv4    => $subnetmatchv4,
    spfwhitelist     => $spfwhitelist,
    user             => $user,
  }
  Class['milter_greylist::package']->Class['milter_greylist::config']~>Class['milter_greylist::service']
}
