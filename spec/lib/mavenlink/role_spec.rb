require "spec_helper"

describe Mavenlink::Role, stub_requests: true, type: :model do
  it_should_behave_like "model", "roles"

  describe "associations" do
    it { is_expected.to respond_to :external_references }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
  end
end
