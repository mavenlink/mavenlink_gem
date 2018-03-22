require "spec_helper"

describe Mavenlink::SkillMembership do
  describe "associations" do
    it { should respond_to :skill }
    it { should respond_to :user }
    it { should respond_to :creator }
  end
end
