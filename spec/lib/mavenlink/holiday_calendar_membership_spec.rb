require "spec_helper"

describe Mavenlink::HolidayCalendarMembership do
  describe "associations" do
    it { should respond_to :holiday_calendar }
    it { should respond_to :user }
  end
end
