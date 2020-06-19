# @summary Configure milter-greylist
#
class milter_greylist::config (
  String $geoipcountryfile,
  String $socketpath,
  String $dumpfile,
  Array[String] $mxpeers,
  Array[String] $whlcountries,
  Array[String] $whlips,
  Array[String] $greyips,
  Array[String] $greyasns,
  String $asncsvfile,
  String $mynetworks,
  String $greylistdelay,
  String $autowhiteperiod,
  String $subnetmatchv4,
  Boolean $spfwhitelist,
  String $user,
){
  if $greyasns != [] {
    $emulation_greyasns = milter_greylist::asn2subnets($greyasns,$asncsvfile)
  }
  else {
    $emulation_greyasns = []
  }

  file {'/etc/mail/greylist.conf':
      ensure  => present,
      content => epp('milter_greylist/greylist.conf.epp', {
        'geoipcountryfile' => $geoipcountryfile,
        'socketpath'       => $socketpath,
        'dumpfile'         => $dumpfile,
        'mxpeers'          => $mxpeers,
        'whlcountries'     => $whlcountries,
        'greyips'          => $greyips,
        'greyasns'         => $emulation_greyasns,
        'mynetworks'       => $mynetworks,
        'greylistdelay'    => $greylistdelay,
        'autowhiteperiod'  => $autowhiteperiod,
        'subnetmatchv4'    => $subnetmatchv4,
        'spfwhitelist'     => $spfwhitelist,
        'user'             => $user,
      }),
    }
}
