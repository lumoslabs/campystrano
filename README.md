Campystrano
===========

This project rocks and uses MIT-LICENSE.

Campystrano adds Campfire deploy hooks into the Capistrano deploy process.

Installation
------------

Add the following to your Gemfile:
```
gem 'campystrano', :git => 'git@github.com:lumoslabs/campystrano.git'
```

In your `config/deploy.rb` file
1. ```require 'capistrano/campystrano'```
2. ```set :campy_config_file, File.expand_path(File.join(File.dirname(__FILE__), 'campystrano.yml'))```

In your ```config``` directory, add a ```campystrano.yml``` file with your Campfire settings.
```
subdomain: mysubdomain
token: 1234567890abc
room: myroom
```
