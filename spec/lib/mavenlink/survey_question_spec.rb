require "spec_helper"

describe Mavenlink::SurveyQuestion, stub_requests: true do
  it_should_behave_like "model", "survey_questions"

  describe "associations" do
    it { should respond_to :choices }
  end
end
