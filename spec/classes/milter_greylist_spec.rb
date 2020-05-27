require 'spec_helper'
default_facts = {
  'networking' => {
    'interfaces' => {
      'eth0' => {
        'ip' => '192.168.1.10',
      },
    },
  },
}

describe 'milter_greylist' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge(default_facts) }

      it { is_expected.to compile }
    end
  end
end
