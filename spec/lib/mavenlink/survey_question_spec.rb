require "spec_helper"

describe Mavenlink::SurveyQuestion, stub_requests: true do
  it_should_behave_like "model", "survey_questions"

  describe "validations" do
    it { is_expected.to validate_presence_of :text }
    it { is_expected.to validate_presence_of :question_type }
  end

  describe "associations" do
    it { is_expected.to respond_to :choices }
  end
end
