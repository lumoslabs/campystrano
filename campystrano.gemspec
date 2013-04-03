$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "campystrano/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "campystrano"
  s.version     = Campystrano::VERSION
  s.authors     = ["Chris Friedrich"]
  s.email       = ["cfriedrich@lumoslabs.com"]
  s.homepage    = "https://github.com/lumoslabs/campystrano"
  s.summary     = "Adds before and after deploy hooks that announce a deploy's start and success in a Campfire room."

  s.files       = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files  = Dir.glob("{spec,test}/**/*.rb")

  s.add_dependency "capistrano",  ">= 2.9"
  s.add_dependency "tinder",      ">= 1.9.2"

  s.add_development_dependency "rails",       "~> 3.2.12"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capistrano-spec"
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'pry-rescue'
  s.add_development_dependency 'pry-stack_explorer'
  s.add_development_dependency 'ruby-debug19'
end
