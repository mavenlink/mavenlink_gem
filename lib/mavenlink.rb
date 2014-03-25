require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'
require 'active_model'
require 'yaml'
require 'json'
require 'brainstem-adaptor'
require 'faraday'
require 'faraday_middleware'

module Mavenlink
  VERSION = '0.0.1'

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

  # @param [String] version
  # @return [Api]
  def self.specification
    @specification ||= BrainstemAdaptor::Specification.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'specification.yml')))
  end

  def self.stub_requests(&block)
    stubbed_requests = Faraday::Adapter::Test::Stubs.new(&block)
    self.adapter = [:test, stubbed_requests]
  end
end

require 'mavenlink/settings'
require 'mavenlink/error'
require 'mavenlink/invalid_request_error'
require 'mavenlink/record_not_found_error'
require 'mavenlink/record_locked_error'
require 'mavenlink/request'
require 'mavenlink/response'
require 'mavenlink/client'
require 'mavenlink/logger'
require 'mavenlink/concerns/indestructible'
require 'mavenlink/concerns/locked_record'
require 'mavenlink/model'
require 'mavenlink/assignment'
require 'mavenlink/story'
require 'mavenlink/story_allocation_day'
require 'mavenlink/role'
require 'mavenlink/user'
require 'mavenlink/workspace'
