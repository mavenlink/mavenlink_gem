require "spec_helper"

describe Mavenlink::Holiday, type: :model do
  describe "associations" do
    it { is_expected.to respond_to :holiday_calendar_associations }
  end
end
