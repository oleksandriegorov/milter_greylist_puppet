require 'spec_helper'

describe 'milter_greylist::mxpeersauto' do
  let(:title) { '13.13.13.13' }
  let(:params) do
    {
      'tag' => 'CloudCluster',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_milter_greylist__mxpeersauto('13.13.13.13') }
      it { is_expected.to contain_milter_greylist__mxpeersauto('13.13.13.13').with_tag('CloudCluster') }
      it { is_expected.to contain_concat__fragment('13.13.13.13').with_target('/etc/mail/greylist.conf').with_content('peer 13.13.13.13') }
    end
  end
end
