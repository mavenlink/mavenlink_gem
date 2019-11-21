require "spec_helper"

describe Mavenlink::ResourceRequest, stub_requests: true, type: :model do
  it_should_behave_like "model", "resource_requests"

  describe "associations" do
    it { is_expected.to respond_to :resource }
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :approvers }
  end
end
