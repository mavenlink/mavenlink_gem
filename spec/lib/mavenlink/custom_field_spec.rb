require "spec_helper"

describe Mavenlink::CustomField, stub_requests: true, type: :model do
  it_should_behave_like "model", "custom_fields"

  describe "associations" do
    it { is_expected.to respond_to :creator }
    it { is_expected.to respond_to :choices }
    it { is_expected.to respond_to :custom_field_set }
    it { is_expected.to respond_to :external_references }
  end
end
