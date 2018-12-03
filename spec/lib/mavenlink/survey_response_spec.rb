require "spec_helper"

describe Mavenlink::SurveyResponse, stub_requests: true do
  it_should_behave_like "model", "survey_responses"

  describe "validations" do
    it { should validate_presence_of :survey_template_id }
  end

  describe "associations" do
    it { should respond_to :survey_template }
    it { should respond_to :survey_answers }
    it { should respond_to :subject }
    it { should respond_to :owner }
    it { should respond_to :respondent }
    it { should respond_to :workspace }
  end
end
