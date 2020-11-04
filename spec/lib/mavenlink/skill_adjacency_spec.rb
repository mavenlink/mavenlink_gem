require "spec_helper"

describe Mavenlink::SkillAdjacency, stub_requests: true, type: :model do
  it_should_behave_like "model", "skill_adjacencies"

  describe "associations" do
    it { is_expected.to respond_to :requested_skill }
    it { is_expected.to respond_to :adjacent_skill }
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :updater }
  end
end
