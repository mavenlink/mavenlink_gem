require "spec_helper"

describe Mavenlink::SurveyAnswer, stub_requests: true do
  it_should_behave_like "model", "survey_answers"

  describe "validations" do
    it { is_expected.to validate_presence_of :survey_response_id }
    it { is_expected.to validate_presence_of :survey_question_id }
  end

  describe "associations" do
    it { is_expected.to respond_to :survey_question }
    it { is_expected.to respond_to :survey_response }
    it { is_expected.to respond_to :choices }
  end
end
