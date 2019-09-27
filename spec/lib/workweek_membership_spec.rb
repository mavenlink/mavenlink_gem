require "spec_helper"

describe Mavenlink::WorkweekMembership do
  describe "associations" do
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :workweek }
  end
end
