require "active_support/core_ext/array/wrap"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/slice"
require "active_support/core_ext/object/deep_dup"
require "active_support/core_ext/object/try"
require "active_support/core_ext/string/conversions"
require "active_support/core_ext/string/inflections"
require "active_model"
require "yaml"
require "json"
require "brainstem-adaptor"
require "faraday"
require "forwardable"

module Mavenlink
  VERSION = "0.0.1".freeze

  # Returns HTTP framework
  def self.adapter
    @adapter || Faraday.default_adapter
  end

  # @param value Any valid Faraday adapter
  def self.adapter=(value)
    @adapter = value
  end

  def self.client
    @client ||= Mavenlink::Client.new
  end

  # @return [Mavenlink::Settings]
  def self.default_settings
    Mavenlink::Settings[:default]
  end

  def self.logger
    @logger ||= Mavenlink::Logger.new(nil)
  end

  def self.logger=(value)
    @logger = value
  end

  # @param token [String]
  def self.oauth_token=(token)
    default_settings[:oauth_token] = token
  end

  # Forces models to perform validations if true
  # If false performs requests without running validations described in specification file
  # Default behavior is not to validate anything
  # @param enabled [true, false]
  def self.perform_validations=(enabled)
    default_settings[:perform_validations] = enabled
  end

  # @param [String] version
  # @return [Api]
  def self.specification
    @specification ||= BrainstemAdaptor::Specification.new(YAML.load_file(File.join(File.dirname(__FILE__), "config", "specification.yml")))
  end

  def self.stub_requests(&block)
    stubbed_requests = Faraday::Adapter::Test::Stubs.new(&block)
    self.adapter = [:test, stubbed_requests]
  end
end

require "mavenlink/settings"
require "mavenlink/errors"
require "mavenlink/request"
require "mavenlink/response"
require "mavenlink/client"
require "mavenlink/logger"
require "mavenlink/concerns/indestructible"
require "mavenlink/concerns/locked_record"
require "mavenlink/specificators/base"
require "mavenlink/specificators/attribute"
require "mavenlink/specificators/association"
require "mavenlink/specificators/validation"
require "mavenlink/subscribed_events/diff"
require "mavenlink/subscribed_events/diff/list"
require "mavenlink/model"
require "mavenlink/scheduled_jobs/insights_report_export"
require "mavenlink/submission"
require "mavenlink/access_group"
require "mavenlink/access_group_membership"
require "mavenlink/account_invitation"
require "mavenlink/account_membership"
require "mavenlink/additional_item"
require "mavenlink/assignment"
require "mavenlink/attachment"
require "mavenlink/backup_approver_association"
require "mavenlink/candidate"
require "mavenlink/cost_rate"
require "mavenlink/custom_field"
require "mavenlink/custom_field_set"
require "mavenlink/custom_field_value"
require "mavenlink/custom_field_choice"
require "mavenlink/estimate"
require "mavenlink/estimate_scenario"
require "mavenlink/estimate_scenario_resource"
require "mavenlink/estimate_scenario_resource_allocation"
require "mavenlink/estimate_scenario_resource_skill"
require "mavenlink/exchange_rate"
require "mavenlink/exchange_table"
require "mavenlink/expense"
require "mavenlink/expense_category"
require "mavenlink/expense_report_submission"
require "mavenlink/external_payment"
require "mavenlink/fixed_fee_item"
require "mavenlink/external_reference"
require "mavenlink/holiday"
require "mavenlink/holiday_calendar"
require "mavenlink/holiday_calendar_association"
require "mavenlink/holiday_calendar_membership"
require "mavenlink/insights_access_group"
require "mavenlink/insights_access_group_membership"
require "mavenlink/invoice"
require "mavenlink/organization"
require "mavenlink/organization_membership"
require "mavenlink/participation"
require "mavenlink/post"
require "mavenlink/project_accounting_record"
require "mavenlink/project_template"
require "mavenlink/project_template_assignment"
require "mavenlink/saml_identity"
require "mavenlink/skill"
require "mavenlink/skill_adjacency"
require "mavenlink/skill_category"
require "mavenlink/skill_membership"
require "mavenlink/staffing_demand"
require "mavenlink/status_report"
require "mavenlink/story"
require "mavenlink/story_allocation_day"
require "mavenlink/story_dependency"
require "mavenlink/story_follow"
require "mavenlink/story_state_change"
require "mavenlink/story_task"
require "mavenlink/subscribed_event"
require "mavenlink/survey_answer"
require "mavenlink/survey_question"
require "mavenlink/survey_question_choice"
require "mavenlink/survey_response"
require "mavenlink/survey_template"
require "mavenlink/tag"
require "mavenlink/time_adjustment"
require "mavenlink/time_entry"
require "mavenlink/time_off_entry"
require "mavenlink/timesheet_submission"
require "mavenlink/rate_card"
require "mavenlink/rate_card_role"
require "mavenlink/rate_card_set"
require "mavenlink/rate_card_set_version"
require "mavenlink/rate_card_version"
require "mavenlink/resolution"
require "mavenlink/resource_request"
require "mavenlink/role" # NOTE(SZ): remove
require "mavenlink/user"
require "mavenlink/vendor"
require "mavenlink/workspace"
require "mavenlink/workspace_allocation"
require "mavenlink/workspace_group"
require "mavenlink/workspace_invoice_preference"
require "mavenlink/workspace_resource"
require "mavenlink/workspace_resource_skill"
require "mavenlink/workweek"
require "mavenlink/workweek_membership"
require "mavenlink/railtie" if defined?(Rails)
