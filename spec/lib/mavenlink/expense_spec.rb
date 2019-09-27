require 'spec_helper'

describe Mavenlink::Expense, stub_requests: true do
  it_should_behave_like 'model', 'expenses'

  describe 'validations' do
    it { is_expected.to validate_presence_of :workspace_id }
    it { is_expected.to validate_presence_of :date }
    it { is_expected.to validate_presence_of :category }
    it { is_expected.to validate_presence_of :amount_in_cents }
  end

  describe 'associations' do
    it { is_expected.to respond_to :expense_category }
    it { is_expected.to respond_to :workspace }
    it { is_expected.to respond_to :user }
    it { is_expected.to respond_to :receipt }
    it { is_expected.to respond_to :external_references }
    it { is_expected.to respond_to :active_submission }
    it { is_expected.to respond_to :role }
    it { is_expected.to respond_to :vendor }
  end
end
