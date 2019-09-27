require "spec_helper"

describe Mavenlink::RecordInvalidError, type: :model do
  let(:client) { Object.new }
  let(:record) { Mavenlink::Workspace.new({ title: nil }, nil, client) }
  before { record.valid? }

  subject { described_class.new(record) }

  describe "#record" do
    subject { super().record }
    it { is_expected.to eq(record) }
  end

  describe "#message" do
    subject { super().message }
    it { is_expected.to eq("Title can't be blank") }
  end

  specify do
    expect { raise subject }.to raise_error described_class, /Title.*blank/
  end
end
