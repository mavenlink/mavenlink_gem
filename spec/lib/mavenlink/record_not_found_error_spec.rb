require 'spec_helper'

describe Mavenlink::RecordNotFoundError do
  subject { described_class.new({response: :data}) }

  specify do
    expect { raise subject }.to raise_error Mavenlink::RecordNotFoundError, /response.*data/
  end
end
