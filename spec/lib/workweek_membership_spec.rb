require "spec_helper"

describe Mavenlink::WorkweekMembership do
  describe "associations" do
    it { should respond_to :user }
    it { should respond_to :workweek }
  end
end
