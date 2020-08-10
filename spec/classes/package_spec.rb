require 'spec_helper'

describe 'milter_greylist::package' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'package_ensure' => 'absent',
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_package('milter-greylist').with_ensure('absent') }
    end
  end
end
