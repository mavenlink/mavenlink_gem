require "spec_helper"

describe Mavenlink::Holiday do
  describe "associations" do
    it { is_expected.to respond_to :holiday_calendar_associations }
  end
end
