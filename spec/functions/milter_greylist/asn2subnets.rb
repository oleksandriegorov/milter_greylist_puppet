require 'spec_helper'
require 'csv'

describe 'milter_greylist::asn2subnets' do
  it { is_expected.to run.with_params(['12200'], Dir.pwd + '/files/GeoLite2-ASN-Blocks-IPv4.csv').and_return(['146.177.20.0/23']) }
  it { is_expected.to run.with_params(['36248'], Dir.pwd + '/files/GeoLite2-ASN-Blocks-IPv4.csv').and_return(['166.86.4.0/22', '208.95.156.0/22']) }
  it { is_expected.to run.with_params(['12200', '36248'], Dir.pwd + '/files/GeoLite2-ASN-Blocks-IPv4.csv').and_return(['146.177.20.0/23', '166.86.4.0/22', '208.95.156.0/22']) }
end
