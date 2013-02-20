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
  2. ```set :campfire_settings { your code here }```

The ```:campfire_settings``` variable must be defined as a hash containing your Campfire account credentials. The ```:subdomain``` and ```:room``` are required. You must also set either a ```:token``` or a ```:username```/```:password``` pair.

For example:
```
set :campfire_settings do
  {
    subdomain: mysubdomain,
    room: myroom,
    token: abcde1234567890fghijk
  }
end
```
