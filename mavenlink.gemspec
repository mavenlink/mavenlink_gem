# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "mavenlink"
  s.version = "0.0.1"

  s.authors = ["Mavenlink"]
  s.email = "opensource@mavenlink.com"
  s.homepage = "http://github.com/mavenlink/mavenlink_gem"

  s.license = "MIT"

  s.files = Dir["lib/**/*", "README.md"]
  s.executables = ["mavenlink-console"]
  s.extra_rdoc_files = ["README.md"]

  s.description = "Simple Ruby API for the Mavenlink API"
  s.summary = "Mavenlink API Ruby Wrapper"

  s.required_ruby_version = ">= 2.7.0"
  s.add_runtime_dependency "activemodel", ">= 4.2"
  s.add_runtime_dependency "activesupport", ">= 4.2", "<= 7.0.8"
  s.add_runtime_dependency "brainstem-adaptor", ">= 0.0.4"
  s.add_runtime_dependency "faraday", ">= 2.0.0"
  s.add_runtime_dependency "faraday-multipart", ">= 1.0.0"
  s.add_development_dependency "awesome_print", "~> 1.8"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop", "~> 0.74"
  s.add_development_dependency "shoulda-matchers", "~> 4.0.0"
end
