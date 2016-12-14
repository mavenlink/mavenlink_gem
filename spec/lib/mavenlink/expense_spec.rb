require 'spec_helper'

describe Mavenlink::Expense, stub_requests: true do
  it_should_behave_like 'model', 'expenses'

  describe 'validations' do
    it { should validate_presence_of :workspace_id }
    it { should validate_presence_of :date }
    it { should validate_presence_of :category }
    it { should validate_presence_of :amount_in_cents }
  end

  describe 'associations' do
    it { should respond_to :expense_category }
    it { should respond_to :workspace }
    it { should respond_to :user }
    it { should respond_to :receipt }
  end
end
