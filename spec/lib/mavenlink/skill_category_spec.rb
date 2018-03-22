require "spec_helper"

describe Mavenlink::SkillCategory do
  describe "associations" do
    it { should respond_to :skills }
  end
end
