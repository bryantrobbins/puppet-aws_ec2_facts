require 'spec_helper'
describe 'aws_ec2_facts' do

  context 'with defaults for all parameters' do
    it { should contain_class('aws_ec2_facts') }
  end
end
