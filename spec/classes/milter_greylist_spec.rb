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

      it { is_expected.to contain_class('milter_greylist::package').that_comes_before('Class[milter_greylist::config]') }
      it { is_expected.to compile }
    end
    context "on #{os} - if package is to be  absent" do
      let(:facts) { os_facts.merge(default_facts) }
      let(:params) do
        {
          'package_ensure' => 'absent',
        }
      end

      it { is_expected.to contain_class('milter_greylist::service').that_comes_before('Class[milter_greylist::package]') }
      it { is_expected.to compile }
    end
  end
end
