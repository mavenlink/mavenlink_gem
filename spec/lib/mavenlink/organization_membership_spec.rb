require "spec_helper"

describe Mavenlink::OrganizationMembership, stub_requests: true, type: :model do
  it_should_behave_like "model", "organization_memberships"

  describe "associations" do
    it { is_expected.to respond_to :geography }
    it { is_expected.to respond_to :department }
  end
end
