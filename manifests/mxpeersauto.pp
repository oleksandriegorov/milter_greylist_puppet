# @summary Resource is used to provide a fragment for milter greylist file with a string "peer $ipaddress"
#
# Resource is used to provide a fragment for milter greylist file with a string "peer $ipaddress"
#
# @example
#   milter_greylist::mxpeersauto { '15.15.15.15': }
define milter_greylist::mxpeersauto (
  Stdlib::IP::Address $ipaddress = $name
) {
  concat::fragment { $ipaddress:
    target  => '/etc/mail/greylist.conf',
    content => "peer ${ipaddress}",
    order   => 5,
  }
}
