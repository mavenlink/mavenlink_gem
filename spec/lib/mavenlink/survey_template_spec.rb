require "spec_helper"

describe Mavenlink::SurveyTemplate, stub_requests: true, type: :model do
  it_should_behave_like "model", "survey_templates"

  describe "validations" do
    it { is_expected.to validate_presence_of :survey_question_ids }
  end

  describe "associations" do
    it { is_expected.to respond_to :survey_questions }
    it { is_expected.to respond_to :survey_responses }
    it { is_expected.to respond_to :subject }
    it { is_expected.to respond_to :owner }
    it { is_expected.to respond_to :respondent }
    it { is_expected.to respond_to :workspace }
  end
end
