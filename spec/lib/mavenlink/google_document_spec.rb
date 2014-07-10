require 'spec_helper'

describe Mavenlink::GoogleDocument, stub_requests: true do

  describe '#save' do
    context 'persisted record' do
      subject { described_class.new(id: 1, private: true) }

      it { should be_persisted }

      specify do
        expect { subject.save }.to raise_error Mavenlink::RecordLockedError
      end
    end
  end

end
