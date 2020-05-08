require "spec_helper"

describe Mavenlink::TimeOffEntry, stub_requests: true, type: :model do
  it_should_behave_like "model", "time_off_entries"

  describe "association" do
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :external_references }
  end

  describe ".create_attributes" do
    let(:subject) { described_class.create_attributes }

    it "includes expected attributes" do
      is_expected.to match_array(%w[user_id hours requested_date external_reference])
    end
  end

  describe ".update_attributes" do
    let(:subject) { described_class.update_attributes }

    it "includes expected attributes" do
      is_expected.to match_array(%w[hours external_reference])
    end
  end
end
