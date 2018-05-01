require "spec_helper"

describe Mavenlink::TimeAdjustment, stub_requests: true do
  it_should_behave_like "model", "time_adjustments"

  describe "associations" do
    it { should respond_to :story }
    it { should respond_to :workspace }
    it { should respond_to :user }
    it { should respond_to :creator }
    it { should respond_to :active_invoice }
  end
end
