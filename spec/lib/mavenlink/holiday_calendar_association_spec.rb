require "spec_helper"

describe Mavenlink::HolidayCalendarAssociation do
  describe "associations" do
    it { should respond_to :holiday }
    it { should respond_to :holiday_calendar }
  end
end
