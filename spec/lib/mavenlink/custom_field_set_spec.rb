require "spec_helper"

describe Mavenlink::CustomFieldSet, stub_requests: true, type: :model do
  it_should_behave_like "model", "custom_field_sets"

  describe "associations" do
    it { is_expected.to respond_to :custom_fields }
  end
end
