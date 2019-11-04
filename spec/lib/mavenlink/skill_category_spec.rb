require "spec_helper"

describe Mavenlink::SkillCategory, type: :model do
  describe "associations" do
    it { is_expected.to respond_to :skills }
  end
end
