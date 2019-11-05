require "spec_helper"

describe Mavenlink::HolidayCalendarMembership, type: :model do
  describe "associations" do
    it { is_expected.to respond_to :holiday_calendar }
    it { is_expected.to respond_to :user }
  end
end
