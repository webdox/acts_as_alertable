$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_alertable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_alertable"
  s.version     = ActsAsAlertable::VERSION
  s.authors     = ["Joaquin"]
  s.email       = ["joaquin@webdox.cl"]
  s.homepage    = ""
  s.summary     = "Summary of ActsAsAlertable."
  s.description = "Description of ActsAsAlertable."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2.7.1"
  s.add_dependency "rspec-rails", ">= 2.14.1"
  s.add_dependency "letter_opener", "~> 1.4.1"
  s.add_dependency "fugit", "~> 1.1.6"
  s.add_development_dependency "sqlite3"
end
