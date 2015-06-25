require 'spec_helper'

describe Google::Calendar do
  subject { lambda { Google::Calendar } }
  it { is_expected.not_to raise_error }

  describe '.client' do
    subject { Google::Calendar.client }
    it { is_expected.to be_instance_of Google::APIClient }
  end

  describe '.api' do
  end
end
