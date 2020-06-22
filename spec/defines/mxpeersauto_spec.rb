require 'spec_helper'

describe 'milter_greylist::mxpeersauto' do
  let(:title) { '13.13.13.13' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
