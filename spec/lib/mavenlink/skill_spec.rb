require "spec_helper"

describe Mavenlink::Skill do
  describe "associations" do
    it { should respond_to :skill_category }
    it { should respond_to :roles }
    it { should respond_to :external_references }
  end
end
