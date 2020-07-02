require "spec_helper"

describe Mavenlink::TimesheetSubmission, stub_requests: true, type: :model do
  subject { described_class.new(id: 5) }

  it_behaves_like "model", "timesheet_submissions"
  it_behaves_like Mavenlink::Submission

  describe "associations" do
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :time_entries }
    it { is_expected.to respond_to :resolutions }
    it { is_expected.to respond_to :external_references }
  end

  it "should respond to expected attributes" do
    is_expected.to respond_to(:start_date, :end_date, :created_at, :updated_at,
                              :status, :title, :comment, :type, :resolution_description,
                              :line_item_total_formatted, :line_item_total_in_cents, :currency,
                              :currency_symbol, :currency_base_unit, :current_resolution_description,
                              :current_resolution_creator_id, :current_resolution_created_at_date,
                              :time_entry_ids, :resolution_ids)
  end

  describe ".create_attributes" do
    let(:subject) { described_class.create_attributes }

    it "includes expected attributes" do
      is_expected.to match_array(%w[title comment workspace_id user_id line_item_ids external_reference])
    end
  end
end
