require 'spec_helper'

describe Google do
  subject { lambda { Google } }
  it { is_expected.not_to raise_error }
end
