require "spec_helper"

describe Mavenlink::TimesheetSubmission, stub_requests: true do
  it_should_behave_like 'model', 'timesheet_submissions'

  describe 'associations' do
    it { should respond_to :user }
    it { should respond_to :workspace }
    it { should respond_to :time_entries }
    it { should respond_to :resolutions }
    it { should respond_to :external_reference }
  end

  it 'should respond to expected attributes' do
    should respond_to(:start_date, :end_date, :created_at, :updated_at,
      :status, :title, :comment, :type, :resolution_description,
      :line_item_total_formatted, :line_item_total_in_cents, :currency,
      :currency_symbol, :currency_base_unit, :current_resolution_description,
      :current_resolution_creator_id, :current_resolution_created_at_date,
      :time_entry_ids, :resolution_ids)
  end

  describe '.create_attributes' do
    let(:subject) { described_class.create_attributes }

    it 'includes expected attributes' do
      should match_array(%w(title comment workspace_id user_id line_item_ids external_reference))
    end
  end
end
