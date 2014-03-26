require 'spec_helper'

describe Mavenlink::RecordInvalidError do
  let(:record) { Mavenlink::Workspace.new(title: nil) }
  before { record.valid? }

  subject { described_class.new(record) }

  its(:record) { should == record }
  its(:message) { should == "Title can't be blank, Creator role is not included in the list" }

  specify do
    expect { raise subject }.to raise_error described_class, /Title.*blank.*Creator.*included/
  end
end
