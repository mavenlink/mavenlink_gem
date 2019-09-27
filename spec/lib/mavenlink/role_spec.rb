require "spec_helper"

describe Mavenlink::Role, stub_requests: true, type: :model do
  it_should_behave_like 'model', 'roles'

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
  end
end
