# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mavenlink}
  s.version = "0.0.1"

  s.date = %q{2014-04-01}
  s.authors = ["Mavenlink"]
  s.email = %q{opensource@mavenlink.com}
  s.homepage = %q{http://github.com/mavenlink/mavenlink_gem}

  s.licenses = ["MIT"]

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.description = %q{Simple Ruby API for the Mavenlink API}
  s.summary = %q{Mavenlink API Ruby Wrapper}

  s.add_runtime_dependency 'activesupport', ">= 3.0.0"
  s.add_runtime_dependency 'activemodel'
  s.add_runtime_dependency 'brainstem-adaptor', ">= 0.0.3"
  s.add_runtime_dependency 'faraday'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'foreman'
  s.add_development_dependency 'guard-rspec'
end


