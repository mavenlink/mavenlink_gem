require "spec_helper"

describe Mavenlink::SkillMembership, type: :model do
  describe "associations" do
    it { is_expected.to respond_to :skill }
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :creator }
  end
end
