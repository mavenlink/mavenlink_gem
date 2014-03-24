require 'spec_helper'

describe Mavenlink::Concerns::LockedRecord do
  subject do
    Class.new do
      def self.create
      end

      include Mavenlink::Concerns::LockedRecord
    end
  end

  specify do
    expect { subject.send(:new).save }.to raise_error Mavenlink::RecordLockedError, /locked.*changed/
  end

  specify do
    expect { subject.send(:new).destroy }.to raise_error Mavenlink::RecordLockedError, /locked.*deleted/
  end

  specify do
    expect { subject.new }.to raise_error NameError, /method.*new/
  end

  specify do
    expect { subject.create }.to raise_error NameError, /method.*create/
  end
end