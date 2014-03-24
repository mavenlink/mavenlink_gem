require 'spec_helper'

describe Mavenlink::InvalidRequestError do
  subject { described_class.new({response: :data}) }

  specify do
    expect { raise subject }.to raise_error Mavenlink::InvalidRequestError, /response.*data/
  end
end