require 'spec_helper'

describe Mavenlink::Attachment, stub_requests: true do
  it_should_behave_like 'model', 'attachments'

  describe 'validations' do
    it { should validate_presence_of :data }
    it { should validate_presence_of :type }
  end

  describe '#save' do
    context 'persisted record' do
      subject { described_class.new(id: 1, data: 'some data', type: 'text') }

      it { should be_persisted }

      specify do
        expect { subject.save }.to raise_error Mavenlink::RecordLockedError
      end
    end

    context 'new record' do
      specify do
        expect { subject.save }.not_to raise_error
      end
    end
  end
end
