require "spec_helper"

describe Mavenlink::Concerns::Indestructible do
  subject do
    Class.new do
      include Mavenlink::Concerns::Indestructible
    end
  end

  specify do
    expect { subject.send(:new).destroy }.to raise_error Mavenlink::RecordLockedError, /locked.*deleted/
  end
end
