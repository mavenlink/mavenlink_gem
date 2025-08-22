require "spec_helper"

describe Mavenlink::ExpenseBudget, stub_requests: true, type: :model do
  it_should_behave_like "model", "expense_budgets"

  describe "attributes" do
    it { is_expected.to respond_to :id }
    it { is_expected.to respond_to :billable }
    it { is_expected.to respond_to :burns_budget }
    it { is_expected.to respond_to :cost_per_unit_in_subunits }
    it { is_expected.to respond_to :description }
    it { is_expected.to respond_to :expected_by }
    it { is_expected.to respond_to :expense_ids }
    it { is_expected.to respond_to :fixed_fee }
    it { is_expected.to respond_to :fixed_fee_item_ids }
    it { is_expected.to respond_to :story_id }
    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :workspace_id }
    it { is_expected.to respond_to :external_reference_ids }
  end

  describe ".create_attributes" do
    let(:subject) { described_class.create_attributes }

    it "includes expected attributes" do
      is_expected.to match_array(%w[billable burns_budget cost_per_unit_in_subunits description expected_by fixed_fee story_id title workspace_id external_reference])
    end
  end

  describe ".update_attributes" do
    let(:subject) { described_class.update_attributes }

    it "includes expected attributes" do
      is_expected.to match_array(%w[billable burns_budget cost_per_unit_in_subunits description expected_by fixed_fee story_id title external_reference])
    end
  end
end
