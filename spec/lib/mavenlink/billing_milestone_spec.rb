require "spec_helper"

describe Mavenlink::BillingMilestone, stub_requests: true, type: :model do
  it_should_behave_like "model", "billing_milestones"

  describe "attributes" do
    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :date_to_invoice }
    it { is_expected.to respond_to :amount_in_cents }
    it { is_expected.to respond_to :workspace_id }
    it { is_expected.to respond_to :story_id }
    it { is_expected.to respond_to :invoice_id }
    it { is_expected.to respond_to :invoice_ids }
    it { is_expected.to respond_to :currency }
    it { is_expected.to respond_to :created_at }
    it { is_expected.to respond_to :updated_at }
    it { is_expected.to respond_to :billing_type }
    it { is_expected.to respond_to :external_reference_ids }
  end

  describe "associations" do
    it { is_expected.to respond_to "invoices" }
    it { is_expected.to respond_to "external_reference" }
  end
end

describe ".create_attributes" do
  let(:subject) { described_class.create_attributes }

  it "includes expected attributes" do
    is_expected.to match_array(%w[title date_to_invoice amount_in_cents workspace_id story_id external_reference])
  end
end

describe ".update_attributes" do
  let(:subject) { described_class.update_attributes }

  it "includes expected attributes" do
    is_expected.to match_array(%w[title date_to_invoice amount_in_cents])
  end
end


end