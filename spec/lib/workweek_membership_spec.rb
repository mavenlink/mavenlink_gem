require "spec_helper"

describe Mavenlink::WorkweekMembership, stub_requests: true, type: :model do
  it_should_behave_like "model", "workweek_memberships"

  it { is_expected.to be_a Mavenlink::Model }

  describe "associations" do
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :workweek }
  end
end
