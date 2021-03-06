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
  Integer $default_ratelimit = 0,
  String $default_ratewindow = '1m',
  Optional[String] $mxpeers_tag = undef,
){
  if $greyasns != [] {
    $emulation_greyasns = milter_greylist::asn2subnets($greyasns,$asncsvfile)
  }
  else {
    $emulation_greyasns = []
  }

  if $mxpeers_tag {
    @@milter_greylist::mxpeersauto { $facts['ipaddress']:
      tag => $mxpeers_tag,
    }

    $target = '/etc/mail/greylist.conf'
    concat { $target:
      owner          => 'root',
      group          => 'root',
      mode           => '0644',
      ensure_newline => true,
      order          => 'numeric',
    }

    concat::fragment { 'pre_peer_part':
      target  => $target,
      content => epp('milter_greylist/pre_peers_greylist.conf.epp', {
        'geoipcountryfile' => $geoipcountryfile,
        'socketpath'       => $socketpath,
        'dumpfile'         => $dumpfile,
        'greylistdelay'    => $greylistdelay,
        'autowhiteperiod'  => $autowhiteperiod,
        'subnetmatchv4'    => $subnetmatchv4,
        'spfwhitelist'     => $spfwhitelist,
        'user'             => $user,
      }),
      order   => 1,
    }

    Milter_greylist::Mxpeersauto <<| tag == $mxpeers_tag |>>

    concat::fragment { 'post_peer_part':
      target  => $target,
      content => epp('milter_greylist/post_peers_greylist.conf.epp', {
        'whlcountries'       => $whlcountries,
        'whlips'             => $whlips,
        'greyips'            => $greyips,
        'greyasns'           => $emulation_greyasns,
        'mynetworks'         => $mynetworks,
        'default_ratelimit'  => $default_ratelimit,
        'default_ratewindow' => $default_ratewindow,

      }),
      order   => 10000,
    }

  }
  else {

    file {'/etc/mail/greylist.conf':
        ensure  => present,
        content => epp('milter_greylist/greylist.conf.epp', {
          'geoipcountryfile'   => $geoipcountryfile,
          'socketpath'         => $socketpath,
          'dumpfile'           => $dumpfile,
          'mxpeers'            => $mxpeers,
          'whlcountries'       => $whlcountries,
          'whlips'             => $whlips,
          'greyips'            => $greyips,
          'greyasns'           => $emulation_greyasns,
          'mynetworks'         => $mynetworks,
          'greylistdelay'      => $greylistdelay,
          'autowhiteperiod'    => $autowhiteperiod,
          'subnetmatchv4'      => $subnetmatchv4,
          'spfwhitelist'       => $spfwhitelist,
          'user'               => $user,
          'default_ratelimit'  => $default_ratelimit,
          'default_ratewindow' => $default_ratewindow,
        }),
      }
  }
}
