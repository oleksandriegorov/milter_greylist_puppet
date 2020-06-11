require 'spec_helper'
greylistconfig = '/etc/mail/greylist.conf'
asncsvfile = Dir.pwd + '/files/GeoLite2-ASN-Blocks-IPv4.csv'

default_facts = {
  'networking' => {
    'interfaces' => {
      'eth0' => {
        'ip' => '192.168.1.10',
      },
    },
  },
}

describe 'milter_greylist::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(default_facts) }
      let(:params) do
        {
          'geoipcountryfile' => '/usr/local/share/GeoIP/GeoIP.dat',
          'socketpath'       => 'inet:3333@127.0.0.1',
          'mxpeers'          => ['192.168.1.10', '192.168.1.11', '192.168.1.12'],
          'whlcountries'     => ['US', 'CA'],
          'whlips'           => [],
          'greyips'          => ['15.15.15.15', '14.13.12.11'],
          'greyasns'         => ['12200', '36248'],
          'asncsvfile'       => asncsvfile,
          'mynetworks'       => '127.0.0.1/8 10.0.0.0/8',
          'greylistdelay'    => '1h',
          'autowhiteperiod'  => '3d',
          'subnetmatchv4'    => '/24',
          'spfwhitelist'     => false,
          'user'             => 'grmilter',
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_file(greylistconfig).with_content(%r{^geoipdb \"/usr/local/share/GeoIP/GeoIP.dat\"}) }
      it { is_expected.to contain_file(greylistconfig).with_content(%r{^peer 192.168.1.10}) }
      it { is_expected.to contain_file(greylistconfig).with_content(%r{^peer 192.168.1.11}) }
      it { is_expected.to contain_file(greylistconfig).with_content(%r{^peer 192.168.1.12}) }
      it { is_expected.to contain_file(greylistconfig).with_content(%r{^list \"whitelisted_countries\" geoip \{ \\\n  \"US\" \\\n  \"CA\" \\\n\}}) }
      it { is_expected.to contain_file(greylistconfig).with_content(%r{^list \"greylisted_ips\" addr \{ \\\n  15.15.15.15 \\\n  14.13.12.11 \\\n\}}) }
      it { is_expected.to contain_file(greylistconfig).with_content(%r{^list \"greylisted_asn_subnets\" addr \{ \\\n  146.177.20.0/23 \\\n  166.86.4.0/22 \\\n  208.95.156.0/22 \\\n\}}) }
    end
  end
end
