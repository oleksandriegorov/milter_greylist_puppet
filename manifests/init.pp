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
#  class {'milter_greylist':
#    mynetworks => '10.0.0.0/8 192.168.0.0/22 127.0.0.1/8',
#  }
#
# @example It is advisable to set certain whitelisted IP addresses or countries to avoid getting into initial delay trouble
#  include milter_greylist
#  class {'milter_greylist':
#    whlcountries => ['CA'],
#      whlips => ['8.8.8.8', '8.8.4.4'],
#  }
#
# @example By default milter-greylist is configured to listen to inet socket, if you have reasons to use unix socket instead try this
#  include milter_greylist
#  class {'milter_greylist':
#    socket => '/var/run/milter-greylist/milter-greylist.sock',
#  }
# 
# @example If you have registered for a free MaxMind account and downloaded CSV file with ASN information you can greylist by ASN number
#  include milter_greylist
#  class {'milter_greylist':
#    asncsvfile => '/usr/local/share/geoip/GeoLite2-ASN-Blocks-IPv4.csv',
#    greyasns   => ['12220','15555','1333'],
#  }
# @param service_ensure
# Controls whether to have service running at the moment
# @param service_enable
# Controls whether to have a service enabled at boot and at all times
# @param package_ensure
# Controls where to have a package installed or not.
# @param geoipcountryfile
#  Specifies the location of GeoIP database
# @param socketpath
#  Specifies the socket used to communicate with MTA
# @param dumpfile
#  Absolute path to greylisting db 
# @param mxpeers
#  Provides a list for synchronization of the greylist among multiple MX
# @param mxpeers_tag
#  Allows for automated population of mxpeers list. Makes sense to use if you have enabled puppetdb.
# @param whlcountries
#  Provides a list of country codes you wish to exclude from a greylist
# @param whlips
#  Provides a list of IP addresses/subnets you wish to exclude from a greylist
# @param greyips 
#  Provides a list of IP addresses/subnets you wish to force into a greylist
# @param greyasns
#  Provides a list of ASNs you wish to exclude from a greylist
# @param asncsvfile
#  If present - path to CSV file with ASN information from MaxMind
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
# @default_ratelimit
# Number of messages per default_ratewindow to allow by default. Defaults to 0, which disables any logic of a rate limit
# @default_ratewindow
# Specifier of a rate time window for default rate limit to act. Defaults to '1m'
class milter_greylist (
  String $service_ensure         = 'running',
  Boolean $service_enable        = true,
  String $package_ensure         = 'present',
  String $geoipcountryfile       = '/usr/local/share/GeoIP/GeoIP.dat',
  String $socketpath             = 'inet:3333@127.0.0.1',
  String $dumpfile               = '/var/lib/milter-greylist/db/greylist.db',
  Array[String] $mxpeers         = [],
  Optional[String] $mxpeers_tag  = undef,
  Array[String] $whlcountries    = ['US','CA'],
  Array[String] $whlips          = [],
  Array[String] $greyips         = [],
  Array[String] $greyasns        = [],
  String $asncsvfile             = '',
  String $mynetworks             = '127.0.0.1/8 10.0.0.0/8',
  String $greylistdelay          = '1h',
  String $autowhiteperiod        = '3d',
  String $subnetmatchv4          = '/24',
  Boolean $spfwhitelist          = false,
  String $user                   = 'grmilter',
  Integer $default_ratelimit     = 0,
  String $default_ratewindow     = '1m',
) {
  include ::stdlib
  class { 'milter_greylist::package':
    package_ensure => $package_ensure,
  }
  class { 'milter_greylist::service':
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }
  class { 'milter_greylist::config':
    geoipcountryfile   => $geoipcountryfile,
    socketpath         => $socketpath,
    dumpfile           => $dumpfile,
    mxpeers            => $mxpeers,
    mxpeers_tag        => $mxpeers_tag,
    whlcountries       => $whlcountries,
    whlips             => $whlips,
    greyips            => $greyips,
    greyasns           => $greyasns,
    asncsvfile         => $asncsvfile,
    mynetworks         => $mynetworks,
    greylistdelay      => $greylistdelay,
    autowhiteperiod    => $autowhiteperiod,
    subnetmatchv4      => $subnetmatchv4,
    spfwhitelist       => $spfwhitelist,
    user               => $user,
    default_ratelimit  => $default_ratelimit,
    default_ratewindow => $default_ratewindow,
  }
  if $package_ensure == 'absent' {
    Class['milter_greylist::service']->Class['milter_greylist::package']
  }
  else {
    Class['milter_greylist::package']->Class['milter_greylist::config']~>Class['milter_greylist::service']
  }
}
