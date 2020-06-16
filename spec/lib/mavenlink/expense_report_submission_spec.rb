require "spec_helper"

describe Mavenlink::ExpenseReportSubmission, stub_requests: true, type: :model do
  it_behaves_like Mavenlink::Submission

  describe "associations" do
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :expenses }
    it { is_expected.to respond_to :resolutions }
    it { is_expected.to respond_to :external_references }
  end
end
