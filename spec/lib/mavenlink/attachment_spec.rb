require 'spec_helper'

describe Mavenlink::Attachment, stub_requests: true do
  it_should_behave_like 'model', 'attachments'

  describe 'validations' do
    it { is_expected.to validate_presence_of :data }
    it { is_expected.to validate_presence_of :type }
    it { is_expected.to ensure_inclusion_of(:type).in_array(%w[receipt post_attachment]) }
    it { is_expected.not_to allow_value(nil).for(:type) }
  end

  describe '#save' do
    context 'persisted record' do
      subject { described_class.new(id: 1, data: 'some data', type: 'receipt') }

      it { is_expected.to be_persisted }

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
