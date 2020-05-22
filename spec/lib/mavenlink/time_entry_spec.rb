require "spec_helper"

describe Mavenlink::TimeEntry, stub_requests: true, type: :model do
  it_should_behave_like "model", "time_entries"

  describe "validations" do
    it { is_expected.to validate_presence_of :workspace_id }
    it { is_expected.to validate_presence_of :date_performed }
    it { is_expected.to validate_presence_of :time_in_minutes }
  end

  describe "associations" do
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :story }
    it { is_expected.to respond_to :role }
    it { is_expected.to respond_to :active_submission }
    it { is_expected.to respond_to :recent_submission }
    it { is_expected.to respond_to :invoice }
    it { is_expected.to respond_to :external_references }
  end

  it "should respond to expected attributes" do
    is_expected.to respond_to(:created_at, :updated_at, :date_performed, :story_id,
                              :time_in_minutes, :billable, :notes, :rate_in_cents,
                              :currency, :currency_symbol, :currency_base_unit,
                              :user_can_edit, :workspace_id, :user_id, :approved,
                              :role_id, :location)
  end

  describe ".create_attributes" do
    let(:subject) { described_class.create_attributes }

    it "includes expected attributes" do
      is_expected.to match_array(%w[workspace_id date_performed time_in_minutes billable cost_rate_in_cents
                                    notes rate_in_cents story_id user_id external_reference location role_id])
    end
  end

  describe ".update_attributes" do
    let(:subject) { described_class.update_attributes }

    it "includes expected attributes" do
      is_expected.to match_array(%w[date_performed time_in_minutes billable notes cost_rate_in_cents
                                    rate_in_cents story_id user_id external_reference role_id workspace_id location])
    end
  end

  describe "#association_load_filters" do
    it "return filters to ensure we get hidden workspaces" do
      expect(subject.association_load_filters).to eq(from_archived_workspaces: true)
    end
  end
end
