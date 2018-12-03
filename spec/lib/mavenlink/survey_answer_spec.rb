require "spec_helper"

describe Mavenlink::SurveyAnswer, stub_requests: true do
  it_should_behave_like "model", "survey_answers"

  describe "associations" do
    it { should respond_to :survey_question }
    it { should respond_to :survey_response }
    it { should respond_to :choices }
  end
end
