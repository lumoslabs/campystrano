$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "campystrano/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "campystrano"
  s.version     = Campystrano::VERSION
  s.authors     = ["Chris Friedrich"]
  s.email       = ["cfriedrich@lumoslabs.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Campystrano."
  s.description = "TODO: Description of Campystrano."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "capistrano",  "~> 2.14.2"
  s.add_dependency "tinder",      "~> 1.9.2"

  s.add_development_dependency "rails",       "~> 3.2.12"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
