require "spec_helper"

describe Mavenlink::ProjectAccountingRecord, stub_requests: true, type: :model do
  it_should_behave_like "model", "project_accounting_records"

  describe "validations" do
    it { is_expected.to validate_presence_of :workspace_id }
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_presence_of :currency }
    it { is_expected.to validate_presence_of :start_date }
    it { is_expected.to validate_presence_of :end_date }
    it { is_expected.to validate_presence_of :type }
  end

  describe "associations" do
    it { is_expected.to respond_to :story }
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :external_references }
  end
end
