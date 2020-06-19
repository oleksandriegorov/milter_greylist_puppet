# @summary Configure milter-greylist
#
class milter_greylist::config (
  String $geoipcountryfile,
  String $socketpath,
  String $dumpfile,
  Array[String] $mxpeers,
  Optional[String] $mxpeers_tag = undef,
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

    Profile::Exportresources::Clusterstype <<| tag == $mxpeers_tag |>>

    concat::fragment { 'post_peer_part':
      target  => $target,
      content => epp('milter_greylist/pre_peers_greylist.conf.epp', {
        'whlcountries'  => $whlcountries,
        'greyips'       => $greyips,
        'greyasns'      => $emulation_greyasns,
        'mynetworks'    => $mynetworks,
        'greylistdelay' => $greylistdelay,
      }),
      order   => 10000,
    }

    file {'/etc/mail/greylist.conf':
        ensure  => present,
        content => epp('milter_greylist/greylist.conf.epp', {
          'geoipcountryfile' => $geoipcountryfile,
          'socketpath'       => $socketpath,
          'dumpfile'         => $dumpfile,
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
  else {

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
}
