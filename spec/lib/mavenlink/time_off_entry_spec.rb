require "spec_helper"

describe Mavenlink::TimeOffEntry, stub_requests: true, type: :model do
  it_should_behave_like "model", "time_off_entries"

  describe "validations" do
    it { is_expected.to validate_presence_of(:hours) }
    it { is_expected.to validate_presence_of(:user_id).on(:create) }
    it { is_expected.to validate_presence_of(:requested_date).on(:create) }
  end

  describe "association" do
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :external_references }
  end

  describe ".create_attributes" do
    let(:subject) { described_class.create_attributes }

    it "includes expected attributes" do
      is_expected.to include("user_id", "hours", "requested_date", "external_reference")
    end
  end

  describe ".update_attributes" do
    let(:subject) { described_class.update_attributes }

    it "includes expected attributes" do
      is_expected.to include("hours", "external_reference")
    end
  end
end
