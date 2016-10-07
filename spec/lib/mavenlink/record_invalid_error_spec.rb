require 'spec_helper'

describe Mavenlink::RecordInvalidError do
  let(:client) { Object.new }
  let(:record) { Mavenlink::Workspace.new({ title: nil }, nil, client) }
  before { record.valid? }

  subject { described_class.new(record) }

  its(:record) { should == record }
  its(:message) { should == "Title can't be blank" }

  specify do
    expect { raise subject }.to raise_error described_class, /Title.*blank/
  end
end
