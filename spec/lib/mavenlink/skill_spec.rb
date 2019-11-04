require "spec_helper"

describe Mavenlink::Skill, type: :model do
  describe "associations" do
    it { is_expected.to respond_to :skill_category }
    it { is_expected.to respond_to :roles }
    it { is_expected.to respond_to :external_references }
  end
end
