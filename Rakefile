#!/usr/bin/env rake

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :spec
task default: :spec

desc 'Runs irb console and initializes the API'
task :console, :token do |_, args|
  require 'irb'
  require 'mavenlink'
  require 'awesome_print'

  token = ENV['TOKEN'] || args[:token]
  Mavenlink.oauth_token = token

  Mavenlink.logger = Mavenlink::Logger.new(STDOUT)
  Mavenlink.logger.level = Logger::DEBUG # Change to Logger::INFO not to display responses
  if token
    Mavenlink.logger.hint "Using #{token} token."
  else
    Mavenlink.logger.disappointment 'No token set! Please put TOKEN=xxxx into your .env file or set manually.'
  end

  AwesomePrint.irb!
  ARGV.clear
  IRB.start
end
