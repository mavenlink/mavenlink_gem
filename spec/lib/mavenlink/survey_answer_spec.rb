require "spec_helper"

describe Mavenlink::SurveyAnswer, stub_requests: true do
  it_should_behave_like "model", "survey_answers"

  describe "validations" do
    it { should validate_presence_of :survey_response_id }
    it { should validate_presence_of :survey_question_id }
  end

  describe "associations" do
    it { should respond_to :survey_question }
    it { should respond_to :survey_response }
    it { should respond_to :choices }
  end
end
