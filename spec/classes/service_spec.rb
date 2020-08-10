require 'spec_helper'

describe 'milter_greylist::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'service_ensure' => 'stopped',
          'service_enable' => false,
        }
      end

      it { is_expected.to contain_service('milter-greylist').with('ensure' => 'stopped', 'enable' => false) }
      it { is_expected.to compile }
    end
  end
end
