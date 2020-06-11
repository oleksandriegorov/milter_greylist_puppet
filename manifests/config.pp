# @summary Configure milter-greylist
#
class milter_greylist::config (
  String $geoipcountryfile,
  String $socketpath,
  Array[String] $mxpeers,
  Array[String] $whlcountries,
  Array[String] $whlips,
  Array[String] $greyips,
  Array[String] $greyasns,
  String $mynetworks,
  String $greylistdelay,
  String $autowhiteperiod,
  String $subnetmatchv4,
  Boolean $spfwhitelist,
  String $user,
){
  file {'/etc/mail/greylist.conf':
      ensure  => present,
      content => epp('milter_greylist/greylist.conf.epp', {
        'geoipcountryfile' => $geoipcountryfile,
        'socketpath'       => $socketpath,
        'mxpeers'          => $mxpeers,
        'whlcountries'     => $whlcountries,
        'greyips'          => $greyips,
        'greyasns'         => $greyasns,
        'mynetworks'       => $mynetworks,
        'greylistdelay'    => $greylistdelay,
        'autowhiteperiod'  => $autowhiteperiod,
        'subnetmatchv4'    => $subnetmatchv4,
        'spfwhitelist'     => $spfwhitelist,
        'user'             => $user,
      }),
    }
}
