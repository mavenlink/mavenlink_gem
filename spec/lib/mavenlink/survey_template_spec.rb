require "spec_helper"

describe Mavenlink::SurveyTemplate, stub_requests: true do
  it_should_behave_like "model", "survey_templates"

  describe "associations" do
    it { should respond_to :survey_questions }
    it { should respond_to :survey_responses }
    it { should respond_to :subject }
    it { should respond_to :owner }
    it { should respond_to :respondent }
    it { should respond_to :workspace }
  end
end
