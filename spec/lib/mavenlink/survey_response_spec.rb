require "spec_helper"

describe Mavenlink::SurveyResponse, stub_requests: true, type: :model do
  it_should_behave_like "model", "survey_responses"

  describe "validations" do
    it { is_expected.to validate_presence_of :survey_template_id }
  end

  describe "associations" do
    it { is_expected.to respond_to :survey_template }
    it { is_expected.to respond_to :survey_answers }
    it { is_expected.to respond_to :subject }
    it { is_expected.to respond_to :owner }
    it { is_expected.to respond_to :respondent }
    it { is_expected.to respond_to :workspace }
  end
end
