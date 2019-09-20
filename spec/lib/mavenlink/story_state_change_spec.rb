require "spec_helper"

describe Mavenlink::StoryStateChange do
  describe "associations" do
    it { should respond_to :user }
    it { should respond_to :story }
  end
end
