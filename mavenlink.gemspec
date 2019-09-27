# -*- encoding: utf-8 -*-

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

  s.add_runtime_dependency "activesupport", "~> 4.2"
  s.add_runtime_dependency "activemodel", "~> 4.2"
  s.add_runtime_dependency "brainstem-adaptor", ">= 0.0.3"
  s.add_runtime_dependency "faraday", ">= 0.9.0"
  s.add_development_dependency "rspec", "2.14.1"
  s.add_development_dependency "shoulda-matchers", "2.5.0"
  s.add_development_dependency "awesome_print"
end
